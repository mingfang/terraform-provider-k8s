package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
)

func main() {
	l := log.New(os.Stdout, "", log.Ldate|log.Ltime)

	port := flag.Int("p", 8000, "HTTP port to listen on")
	flag.Parse()

	routes := map[string]string{
		"/terraform":  "terraform",
		"/terragrunt": "terragrunt",
	}
	l.Printf("Serving routes: %s on port: %d", routes, *port)
	server := NewServer(routes, *port)
	server.Start()
}

type Server struct {
	port int
}

func NewServer(routes map[string]string, port int) *Server {
	server := Server{
		port: port,
	}
	server.initRoutes(routes)

	return &server
}

func (this *Server) Start() {
	http.ListenAndServe(fmt.Sprintf("0.0.0.0:%d", this.port), nil)
}

func (this *Server) initRoutes(routes map[string]string) {
	for path, command := range routes {
		http.HandleFunc(path, this.handleRoute(command))
	}
}

func (this *Server) handleRoute(command string) http.HandlerFunc {
	logger := log.New(os.Stdout, command+" ", log.Ldate|log.Ltime)
	fields := strings.Fields(command)
	return func(w http.ResponseWriter, r *http.Request) {
		var argString string
		if r.Body != nil {
			data, err := ioutil.ReadAll(r.Body)
			if err != nil {
				logger.Print(err)
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			argString = string(data)
		}

		args := append(fields[1:], strings.Fields(argString)...)
		logger.Printf("%s %s", fields[0], strings.Join(args, " "))

		output, err := exec.Command(fields[0], args...).CombinedOutput()
		w.Header().Set("Content-Type", "text/plain")
		w.Write(output)
		if err != nil {
			fmt.Fprint(w, err.Error())
			logger.Printf("Command: [%s %s] Error: %s", fields[0], strings.Join(args, " "), err.Error())
		}
	}
}
