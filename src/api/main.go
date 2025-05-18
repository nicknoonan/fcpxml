package main

import (
	"os"
	"log"
	"github.com/nicknoonan/fcpxml/src/parser"
)

func main() {
	args := os.Args
	if len(args) > 1 {
		contentBytes, err := os.ReadFile(args[1])
		if err != nil {
			log.Fatalf("Error while loading fcpxml file: %v", err)
		}
		result, err := Parse(string(contentBytes))
		if err != nil {
			log.Fatalf("Error while parsing: %v", err)
		}
		log.Println(result)
	}
}