package clipboard

import (
	"runtime"
	"testing"
)

func TestGetRequiredDependencies(t *testing.T) {
	deps := GetRequiredDependencies()

	if len(deps) == 0 {
		t.Error("Expected dependencies, got none")
	}

	switch runtime.GOOS {
	case "linux":
		if len(deps) < 2 {
			t.Error("Expected at least 2 dependencies for Linux")
		}
	case "darwin", "windows":
		if len(deps) != 1 {
			t.Error("Expected exactly 1 dependency for macOS/Windows")
		}
	}
}

func TestIsAvailable(t *testing.T) {
	available := IsAvailable()
	t.Logf("Clipboard available: %v", available)
}
