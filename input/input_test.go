package input

import (
	"testing"
)

func TestHasStdinData(t *testing.T) {
	// In normal test environment, this should return false
	hasData := HasStdinData()
	t.Logf("Has stdin data: %v", hasData)

	// This test mainly ensures the function doesn't panic
}
