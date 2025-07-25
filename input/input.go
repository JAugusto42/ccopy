package input

import (
	"io"
	"os"
)

func HasStdinData() bool {
	stat, err := os.Stdin.Stat()
	if err != nil {
		return false
	}

	if (stat.Mode() & os.ModeCharDevice) == 0 {
		return true
	}

	return false
}

func ReadStdin() ([]byte, error) {
	return io.ReadAll(os.Stdin)
}

func ReadStdinString() (string, error) {
	data, err := ReadStdin()
	if err != nil {
		return "", err
	}
	return string(data), nil
}
