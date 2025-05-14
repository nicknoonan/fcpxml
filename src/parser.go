package main

import (
	"fmt"
	"maps"
	"reflect"

	//"log"
	"math/big"
	"strings"

	"github.com/clbanning/mxj/v2"
	"time"
	"sort"
)

func Parse(contents string) (string, error) {
	
	if (strings.Trim(contents, "\n") == "") {
		return "", nil
	}
	xml, err := mxj.NewMapXml([]byte(contents))
	if err != nil {
		return "", err
	}

	ele, _ := xml.ValueForPath("fcpxml")
	parsedContent := ""
	// iterate the list of chapter marker XML paths
	root := []map[string]interface{}{ele.(map[string]interface{})}
	markers := findChapterMarker(0.0,0.0,"fcpxml",root,[]string{})
	sort.Strings(markers)
	for _, marker := range markers {
		parsedContent += marker
		parsedContent += "\n"
	}
	return parsedContent, nil
}

func findChapterMarker(start, offset float64, tag string, xml []map[string]interface{}, acc []string) ([]string) {
	// if chapter markers then 
	// do a little math and 
	// format a little string
	// and do a little twirl
	if (tag == "chapter-marker") {
		for _, element := range xml {
			startString := element["-start"].(string)
			if (start == 0) { 
				start = ParseRationalTimeString(startString)
			} else {
				start -= ParseRationalTimeString(startString)
			}
			marker := FormatTimeStamp(start, offset, element["-value"].(string))
			acc = append(acc, marker)
		}
		return acc
	}

	// recursively look for chapter marker in child elements of current element
	curStart := start
	curOffset := offset
	for _, xmlObj := range xml {
		for key := range maps.Keys(xmlObj) {
			start = curStart
			offset = curOffset
			if !strings.HasPrefix(key, "-") {
				keyType := reflect.TypeOf(xmlObj[key])
				keyTypeKind := keyType.Kind()
				var children []map[string]interface{}
				if (keyTypeKind == reflect.Array || keyTypeKind == reflect.Slice) {
					for _, child := range xmlObj[key].([]interface{}) {
						kind := reflect.TypeOf(child).Kind()
						if (kind == reflect.Map) {
							children = append(children, child.(map[string]interface{}))
						}
					}
				} else if (keyTypeKind == reflect.String) {
					return acc
				} else if (keyTypeKind == reflect.Map) {
					child := xmlObj[key].(map[string]interface{})
					children = append(children, child)
				} else {
					panic("unknown key type")
				}
				if ((xmlObj["-offset"] != nil) && (tag != "spine") && (offset == 0.0)) {
					offsetString := xmlObj["-offset"].(string)
					offset += ParseRationalTimeString(offsetString)
				}
				if ((xmlObj["-start"] != nil) && (tag != "spine")) {
					startString := xmlObj["-start"].(string)
					if (start == 0) { 
						start = ParseRationalTimeString(startString)
					} else {
						start -= ParseRationalTimeString(startString)
					}
				}
				acc = findChapterMarker(start, offset, key, children, acc)
			}
		}
	}

	// if tag isn't chapter marker and has no child elements return accumulator
	return acc
}

func FormatMarkerString(name, time string) (string) {
	return fmt.Sprintf("%s  %s", name, time)
}

func ParseRationalTimeString(time string) (float64) {
	seconds := 0.0
	rat := new(big.Rat)
	offsetRat, ok := rat.SetString(strings.Trim(time, "s"))
	if (!ok) {
		// this should be handled better
	}
	seconds, _ = offsetRat.Float64()
	if (seconds >= 3600) {
		return seconds - 3600
	}
	return seconds
}

func FormatTimeStamp(start, offset float64, value string) (string) {
	timeValue, _ := time.Parse(time.RFC3339, "1998-12-03T00:00:00Z")
	duration, err := time.ParseDuration(fmt.Sprintf("%ds",int(offset+start)))
	if (err != nil) {
		panic("failed to parse time duration")
	}
	timeValue = timeValue.Add(duration)
	
	return fmt.Sprintf("%s %s", timeValue.Format(time.TimeOnly), value)
}
