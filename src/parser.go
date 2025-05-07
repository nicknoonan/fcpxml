package main

import (
	"log"
	"github.com/clbanning/mxj/v2"
)

func Parse(contents string) (string, error) {
	mymap, err := mxj.NewMapXml([]byte(contents))
	if err != nil {
		return "", err
	}
	// log.Println(mymap.StringIndent())
	//mymap.PathsForKey("chapter-marker")
	log.Println(mymap.PathsForKey("chapter-marker"))
	log.Println(mymap.ValuesForPath("fcpxml.library.event.project.sequence.spine.asset-clip.chapter-marker"))
	return mymap.StringIndent(), nil
}