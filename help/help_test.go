package help

import (
	"strings"
	"testing"
)

func TestGetHelpText(t *testing.T) {
	helpText := GetHelpText()

	if len(helpText) == 0 {
		t.Error("Help text should not be empty")
	}

	if !strings.Contains(helpText, "ccopy") {
		t.Error("Help text should contain 'ccopy'")
	}

	if !strings.Contains(helpText, "Usage:") {
		t.Error("Help text should contain 'Usage:'")
	}
}

func TestGetDependenciesText(t *testing.T) {
	depsText := GetDependenciesText()

	if len(depsText) == 0 {
		t.Error("Dependencies text should not be empty")
	}

	if !strings.Contains(depsText, "Dependencies:") {
		t.Error("Dependencies text should contain 'Dependencies:'")
	}
}

func TestShowVersion(t *testing.T) {
	ShowVersion("")
	ShowVersion("1.0.0")
}
