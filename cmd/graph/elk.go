package main

type ElkPoint struct {
	X int `json:"x"`
	Y int `json:"y"`
}

type ElkGraphElement struct {
	ID     string      `json:"id"`
	Labels []*ElkLabel `json:"labels,omitempty"`
}

type ElkShape struct {
	ElkGraphElement

	X      int `json:"x,omitempty"`
	Y      int `json:"y,omitempty"`
	Width  int `json:"width,omitempty"`
	Height int `json:"height,omitempty"`
}

type ElkProperties struct {
	EdgeRouting                         string `json:"elk.layered.edgeRouting,omitempty"`
	LayeredCrossingMinimizationStrategy string `json:"elk.layered.crossingMinimization.strategy,omitempty"`
	LayeredHighDegreeNodesThreshold     int    `json:"elk.layered.highDegreeNodes.threshold,omitempty"`
	LayeredHighDegreeNodesTreatment     string `json:"elk.layered.highDegreeNodes.treatment,omitempty"`
	LayeredSpacingEdgeEdgeBetweenLayers int    `json:"elk.layered.spacing.edgeEdgeBetweenLayers,omitempty"`
	LayeredSpacingEdgeNodeBetweenLayers int    `json:"elk.layered.spacing.edgeNodeBetweenLayers,omitempty"`
	LayeredSpacingNodeNodeBetweenLayers int    `json:"elk.layered.spacing.nodeNodeBetweenLayers,omitempty"`
	NodeLabelsPlacement                 string `json:"elk.nodeLabels.placement,omitempty"`
	NodePlacementFavorStraightEdges     string `json:"elk.nodePlacement.favorStraightEdges,omitempty"`
	Padding                             string `json:"elk.padding,omitempty"`
	PortConstraints                     string `json:"elk.portConstraints,omitempty"`
	PortSide                            string `json:"elk.port.side,omitempty"`
	SpacingComponentComponent           int    `json:"elk.spacing.componentComponent,omitempty"`
	SpacingEdgeNode                     int    `json:"elk.spacing.edgeNode,omitempty"`
	SpacingNodeNode                     int    `json:"elk.spacing.nodeNode,omitempty"`
	SpacingPortPort                     int    `json:"elk.spacing.portPort,omitempty"`
}

type ElkNode struct {
	ElkShape

	Children   []*ElkNode     `json:"children,omitempty"`
	Ports      []*ElkPort     `json:"ports,omitempty"`
	Edges      []*ElkEdge     `json:"edges,omitempty"`
	Properties *ElkProperties `json:"properties,omitempty"`
}

type ElkPort struct {
	ElkShape

	Properties *ElkProperties `json:"properties,omitempty"`
}

type ElkLabel struct {
	ElkShape

	Text string `json:"text,omitempty"`
}

type ElkEdge struct {
	ElkGraphElement

	Sources []string `json:"sources,omitempty"`
	Targets []string `json:"targets,omitempty"`
}

type ElkExtendedEdge struct {
	ElkEdge

	sources  []string
	targets  []string
	sections []*ElkEdgeSection
}

type ElkEdgeSection struct {
	ElkGraphElement

	startPoint       ElkPoint
	endPoint         ElkPoint
	bendPoints       []*ElkPoint
	incomingShape    string
	outgoingShape    string
	incomingSections []string
	outgoingSections []string
}
