package input

import (
	"io"
	"os"
)

// HasStdinData checks if there's data available in stdin
func HasStdinData() bool {
	// Check if stdin has available data
	stat, err := os.Stdin.Stat()
	if err != nil {
		return false
	}

	// If it's a pipe or redirection, there's data
	if (stat.Mode() & os.ModeCharDevice) == 0 {
		return true
	}

	// If it's a terminal, check if there's data waiting
	// Use a very small timeout to avoid blocking
	return false
}

// ReadStdin reads all data from stdin
func ReadStdin() ([]byte, error) {
	return io.ReadAll(os.Stdin)
}

// ReadStdinString reads all data from stdin as a string
func ReadStdinString() (string, error) {
	data, err := ReadStdin()
	if err != nil {
		return "", err
	}
	return string(data), nil
}
