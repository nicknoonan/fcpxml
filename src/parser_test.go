package main

import (
	"fmt"
	"strings"
	"testing"
	"github.com/hexops/gotextdiff"
	"github.com/hexops/gotextdiff/myers"
	"github.com/hexops/gotextdiff/span"
)

func linewiseDiff(expected, actual string) string {
	edits := myers.ComputeEdits(span.URIFromPath("expected"), expected, actual)
	return fmt.Sprint(gotextdiff.ToUnified("expected","actual",expected,edits))
}

func TestParser(t *testing.T) {
	tests := []struct {
		name string
		content string
		expectedContent string
	}{
		{
			name: "empty file",
			content: "",
			expectedContent: "",
		},
		{
			name: "should fail",
			content: "",
			expectedContent: "expected\n",
		},
	}
	for _, testCase := range tests {
		t.Run(testCase.name, func(t *testing.T) {
			result, err := Parse(testCase.content)
			if err != nil {
				t.Errorf("Error while parsing: %v", err)
			}

			expectedNormalized := strings.ReplaceAll(testCase.expectedContent, "\r\n", "\n")
			resultNormalized := strings.ReplaceAll(result, "\r\n", "\n")

			if expectedNormalized != resultNormalized {
				t.Errorf("Expected and actual content don't match:%s",linewiseDiff(expectedNormalized,resultNormalized))
			}
		})
	}
}