package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"

	"github.com/awalterschulze/gographviz"
	"github.com/awalterschulze/gographviz/ast"
)

func main() {
	var title = ""
	if len(os.Args) > 1 {
		title = os.Args[1]
	}
	mainDot(title)
	//log.Println(getModule("[root] module.test.k8s_apps_v1_deployment.this"))
}

func mainTestGraph() {
	graph := ElkNode{
		ElkShape: ElkShape{
			ElkGraphElement: ElkGraphElement{
				ID: "root",
			},
		},
		Children: []*ElkNode{
			&ElkNode{
				ElkShape: ElkShape{
					ElkGraphElement: ElkGraphElement{
						ID: "n1",
					},
					Width:  30,
					Height: 30,
				},
				Ports: []*ElkPort{
					&ElkPort{
						ElkShape: ElkShape{
							ElkGraphElement: ElkGraphElement{
								ID: "n1p1",
							},
							Width:  10,
							Height: 10,
						},
					},
				},
			},
			&ElkNode{
				ElkShape: ElkShape{
					ElkGraphElement: ElkGraphElement{
						ID: "n2",
					},
					Width:  30,
					Height: 30,
				},
			},
			&ElkNode{
				ElkShape: ElkShape{
					ElkGraphElement: ElkGraphElement{
						ID: "n3",
					},
					Width:  30,
					Height: 30,
				},
			},
		},
		Edges: []*ElkEdge{
			&ElkEdge{
				ElkGraphElement: ElkGraphElement{
					ID: "e1",
				},
				Sources: []string{"n1"},
				Targets: []string{"n2"},
			},
		},
	}

	var jsonData []byte
	jsonData, err := json.Marshal(graph)
	if err != nil {
		log.Println(err)
	}
	fmt.Println(string(jsonData))

}

func mainDot(title string) {
	//filename := "./cmd/graph/nfs.dot"
	//filename := "./cmd/graph/graph.dot"
	//filename := "./cmd/graph/gitlab.dot"
	//filename := "./cmd/graph/gitlab-solution.dot"
	//dotBytes, fileErr := ioutil.ReadFile(filename)
	dotBytes, fileErr := ioutil.ReadAll(os.Stdin)
	if fileErr != nil {
		log.Fatalln(fileErr)
	}

	visitor := graphVisitor{
		title: title,
	}
	graphAst, _ := gographviz.Parse(dotBytes)
	graphAst.Walk(&visitor)

	var jsonData []byte
	jsonData, err := json.MarshalIndent(visitor.elkGraph, "", "  ")
	if err != nil {
		log.Println(err)
	}
	fmt.Println(string(jsonData))

}

type nilVisitor struct {
}

func (w *nilVisitor) Visit(v ast.Elem) ast.Visitor {
	return w
}

type debugVisitor struct {
}

func (this *debugVisitor) Visit(e ast.Elem) ast.Visitor {
	log.Println(e)
	return this
}

type graphVisitor struct {
	elkGraph *ElkNode
	title    string
}

func (this *graphVisitor) Visit(e ast.Elem) ast.Visitor {
	graph, ok := e.(*ast.Graph)
	if !ok {
		return this
	}
	key := graph.ID.String()
	if key == "" {
		key = "graph"
	}
	log.Println("Graph ID:", key)
	this.elkGraph, _ = makeElkNode(key, "", true)
	return &stmtVisitor{
		title:    this.title,
		elkGraph: this.elkGraph,
	}
}

var nodes = map[string]*ElkNode{}

var ports = map[string]*ElkPort{}

func makeElkNode(key string, label string, isContainer bool) (*ElkNode, bool) {
	if elkNode, exists := nodes[key]; exists {
		return elkNode, false
	}

	if label == "" {
		label = key
	}
	label = strings.TrimPrefix(label, "[root] ")

	var nodeLabelsPlacement string
	if isContainer {
		nodeLabelsPlacement = "H_LEFT V_TOP OUTSIDE"
	} else {
		nodeLabelsPlacement = "H_LEFT V_CENTER INSIDE"
	}
	elkNode := ElkNode{
		ElkShape: ElkShape{
			ElkGraphElement: ElkGraphElement{
				ID: nextID(),
			},
			Width:  200,
			Height: 60,
		},
		Properties: &ElkProperties{
			NodeLabelsPlacement:                 nodeLabelsPlacement,
			Padding:                             "[left=100, top=50, right=100, bottom=50]",
			PortConstraints:                     "FIXED_SIDE",
			SpacingComponentComponent:           50,
			SpacingEdgeNode:                     50,
			SpacingNodeNode:                     100,
			SpacingPortPort:                     50,
			LayeredSpacingEdgeEdgeBetweenLayers: 50,
			LayeredSpacingEdgeNodeBetweenLayers: 50,
			LayeredSpacingNodeNodeBetweenLayers: 200,
			//NodePlacementFavorStraightEdges: "false",
			//LayeredHighDegreeNodesTreatment: "true",
			//LayeredHighDegreeNodesThreshold: 2,
			//EdgeRouting:                         "POLYLINE",
			//LayeredCrossingMinimizationStrategy: "INTERACTIVE",
		},
	}
	elkLabel := ElkLabel{
		ElkShape: ElkShape{
			ElkGraphElement: ElkGraphElement{
				ID: nextID(),
			},
			Height: 16,
		},
		//Text: key,
		Text: label,
	}
	elkNode.Labels = append(elkNode.Labels, &elkLabel)

	nodes[key] = &elkNode
	return &elkNode, true
}

func makeElkPort(key string, label string, side string) (*ElkPort, bool) {
	if elkPort, exists := ports[key]; exists {
		return elkPort, false
	}
	if label == "" {
		label = key
	}
	elkPort := ElkPort{
		ElkShape: ElkShape{
			ElkGraphElement: ElkGraphElement{
				ID: nextID(),
			},
			Width:  16,
			Height: 9,
		},
		Properties: &ElkProperties{
			PortSide: side,
		},
	}
	elkLabel := ElkLabel{
		ElkShape: ElkShape{
			ElkGraphElement: ElkGraphElement{
				ID: nextID(),
			},
		},
		Text: label,
	}
	elkPort.Labels = append(elkPort.Labels, &elkLabel)

	ports[key] = &elkPort
	return &elkPort, true
}

var skipPaths = []*regexp.Regexp{
	regexp.MustCompile(`^\[root] root.*`),
	regexp.MustCompile(`^\[root] provider.*`),
	regexp.MustCompile(`^\[root] meta.*`),
	regexp.MustCompile(`.* \(close\)`),
}

//[root] module.deployment-service.k8s_apps_v1_deployment.this
func IsSkipNode(path string) bool {
	for _, pattern := range skipPaths {
		//log.Println("isSkipPath:", path)
		if pattern.MatchString(path) {
			//log.Println("SkipPath:", path)
			return true
		}
	}
	return false
}

type stmtVisitor struct {
	elkGraph *ElkNode
	title    string
}

func (this *stmtVisitor) Visit(e ast.Elem) ast.Visitor {
	switch astType := e.(type) {
	case ast.NodeStmt:
		//log.Println("NodeStmt:", this.elkGraph.ID)
		//return this.visitNodeStmt(astType)
		return &nilVisitor{}
	case ast.EdgeStmt:
		//log.Println("EdgeStmt:", this.elkGraph.ID)
		return this.visitEdgeStmt(astType)
	case ast.NodeAttrs:
		//log.Println("NodeAttrs:", astType)
		return &nilVisitor{}
	case ast.EdgeAttrs:
		//log.Println("EdgeAttrs:", astType)
		return &nilVisitor{}
	case ast.GraphAttrs:
		//log.Println("GraphAttrs:", astType)
		return &nilVisitor{}
	case *ast.SubGraph:
		//log.Println("SubGraph:", this.elkGraph.ID)
		return this.visitSubGraph(astType)
	case *ast.Attr:
		//log.Println("Attr:", astType)
		return &nilVisitor{}
	case ast.AttrList:
		//log.Println("AttrList:", astType)
		return &nilVisitor{}
	default:
		//fmt.Fprintf(os.Stderr, "unknown stmt %T\n", v)
	}
	return this
}

func (this *stmtVisitor) visitSubGraph(stmt *ast.SubGraph) ast.Visitor {
	id := stmt.ID.String()
	id = id[1 : len(id)-1]
	//log.Println("subgraph id:", id)
	elkGraph, isNew := makeElkNode(id, this.title, true)
	if isNew {
		this.elkGraph.Children = append(this.elkGraph.Children, elkGraph)
	}
	return &stmtVisitor{
		elkGraph: elkGraph,
	}
}

func (this *stmtVisitor) visitNodeStmt(stmt ast.NodeStmt) ast.Visitor {
	id := stmt.NodeID.String()
	id = id[1 : len(id)-1]
	if IsSkipNode(id) {
		return &nilVisitor{}
	}
	key := id
	parent := this.elkGraph
	moduleNode, rest := makeAllModuleNodes(parent, id)
	if moduleNode != nil {
		parent = moduleNode
		id = rest
	}
	if elkNode, isNew := makeElkNode(key, id, false); isNew {
		parent.Children = append(parent.Children, elkNode)
	}
	return &nilVisitor{}
}

func (this *stmtVisitor) visitEdgeStmt(stmt ast.EdgeStmt) ast.Visitor {
	var edgeSourceID string
	var edgeTargetID string
	var sourceNode *ElkNode
	var targetNode *ElkNode

	source := stmt.Source.GetID().String()
	source = source[1 : len(source)-1]
	if IsSkipNode(source) {
		return &nilVisitor{}
	}
	target := stmt.EdgeRHS[0].Destination.GetID().String()
	target = target[1 : len(target)-1]
	if IsSkipNode(target) {
		return &nilVisitor{}
	}

	sourceKey := source
	targetKey := target
	//log.Println("source:", source, "target:", target)

	//source
	sourceModuleNode, sourceRest := makeAllModuleNodes(this.elkGraph, source)
	if sourceModuleNode != nil {
		sourceNode = sourceModuleNode
		source = sourceRest
	} else {
		sourceNode = this.elkGraph
	}
	sourceType, sourceName := getVarOrOut(source)
	if sourceType != "" {
		port, isNew := makeElkPort(sourceKey, sourceName, side(sourceType))
		if isNew {
			sourceNode.Ports = append(sourceNode.Ports, port)
		}
		edgeSourceID = port.ID
	} else {
		node, isNew := makeElkNode(sourceKey, source, false)
		if isNew {
			sourceNode.Children = append(sourceNode.Children, node)
		}
		sourceNode = node
		edgeSourceID = sourceNode.ID
	}
	//log.Println(edgeSourceID)

	//target
	targetModuleNode, targetRest := makeAllModuleNodes(this.elkGraph, target)
	if targetModuleNode != nil {
		targetNode = targetModuleNode
		target = targetRest
	} else {
		targetNode = this.elkGraph
	}
	targetType, targetName := getVarOrOut(target)
	if targetType != "" {
		port, isNew := makeElkPort(targetKey, targetName, side(targetType))
		if isNew {
			targetNode.Ports = append(targetNode.Ports, port)
		}
		edgeTargetID = port.ID
	} else {
		node, isNew := makeElkNode(targetKey, target, false)
		if isNew {
			targetNode.Children = append(targetNode.Children, node)
		}
		targetNode = node
		edgeTargetID = targetNode.ID
	}
	//log.Println(edgeTargetID)

	//create edge
	elkEdge := ElkEdge{
		ElkGraphElement: ElkGraphElement{
			ID: nextID(),
		},
		Sources: []string{edgeTargetID},
		Targets: []string{edgeSourceID},
	}
	this.elkGraph.Edges = append(this.elkGraph.Edges, &elkEdge)
	return this
}

func side(portType string) string {
	if portType == "var" {
		return "WEST"
	} else {
		return "EAST"
	}
}

func makeAllModuleNodes(parent *ElkNode, str string) (*ElkNode, string) {
	sourceModule, sourceRest := getModule(str)
	if sourceModule != "" {
		node, isNew := makeElkNode(parent.ID+sourceModule, sourceModule, true)
		if isNew {
			parent.Children = append(parent.Children, node)
		}
		return makeAllModuleNodes(node, sourceRest)
	} else {
		return parent, str
	}
}

var modulePattern = regexp.MustCompile(`(?Um).*module\.([^.]+)\.(.*)$`)

func getModule(str string) (string, string) {
	parts := modulePattern.FindStringSubmatch(str)
	if len(parts) != 3 {
		return "", ""
	} else {
		//log.Println("getModule for", str, "module:", parts[1], "rest:", parts[2])
		return parts[1], parts[2]
	}
}

var varOrOutPattern = regexp.MustCompile(`(?m)(var|output)\.(\w+)`)

func getVarOrOut(str string) (string, string) {
	parts := varOrOutPattern.FindStringSubmatch(str)
	if len(parts) != 3 {
		return "", ""
	} else {
		return parts[1], parts[2]
	}
}

var idCounter = 0

func nextID() string {
	idCounter++
	return strconv.Itoa(idCounter)
}
