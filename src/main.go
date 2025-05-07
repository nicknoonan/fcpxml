package main

import (
	"os"
	"log"
)

func main() {
	args := os.Args
	if len(args) > 1 {
		contentBytes, err := os.ReadFile(args[1])
		if err != nil {
			log.Fatalf("Error while loading test file: %v", err)
		}
		result, err := Parse(string(contentBytes))
		if err != nil {
			log.Fatalf("Error while parsing: %v", err)
		}
		log.Println(result)
	}
}