package input

import (
	"testing"
)

func TestHasStdinData(t *testing.T) {
	hasData := HasStdinData()
	t.Logf("Has stdin data: %v", hasData)
}
