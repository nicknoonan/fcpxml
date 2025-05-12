package main

import (
	"fmt"
	"os"
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
		contentPath string
		expectedContent string
	}{
		{
			name: "empty file",
			contentPath: "empty.fcpxml",
			expectedContent: "",
		},
		{
			name: "complicated",
			contentPath: "example_complicated.fcpxml",
			expectedContent: `0:00 A
0:00 B
0:00 C
0:00 D`,
		},
		{
			name: "simple",
			contentPath: "example_simple.fcpxml",
			expectedContent: `00:00:00 A
00:02:14 C
00:02:38 D
`,
	 	},
		{
			name: "simple2",
			contentPath: "example_simple_2.fcpxml",
			expectedContent: `0:00 A
0:00 B
0:00 C
0:00 D`,
		},
		{
			name: "real project",
			contentPath: "example_i_think_this_one_is_a_real_project.fcpxml",
			expectedContent: `0:00 A
0:00 B
0:00 C
0:00 D`,
		},
	}
	for _, testCase := range tests {
		t.Run(testCase.name, func(t *testing.T) {
			contentBytes, err := os.ReadFile(testCase.contentPath)
			if err != nil {
				t.Errorf("Error while loading test file: %v", err)
			}
			result, err := Parse(string(contentBytes))
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