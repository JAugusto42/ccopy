package help

import (
	"fmt"
	"runtime"
)

// Show displays the help message
func Show() {
	fmt.Println(GetHelpText())
}

// GetHelpText returns the help message as a string
func GetHelpText() string {
	return `ccopy - Copy terminal text to clipboard

Usage:
  command | ccopy          # Copy command output
  echo "text" | ccopy      # Copy specific text
  cat file.txt | ccopy     # Copy file contents

Examples:
  ls -la | ccopy
  ps aux | ccopy
  curl -s api.example.com | ccopy
  git log --oneline -10 | ccopy
  docker ps | ccopy
  
` + GetDependenciesText()
}

// GetDependenciesText returns OS-specific dependency information
func GetDependenciesText() string {
	switch runtime.GOOS {
	case "linux":
		return `Linux Dependencies:
  - xclip (recommended): sudo apt install xclip
  - or xsel: sudo apt install xsel`
	case "darwin":
		return `macOS Dependencies:
  - pbcopy (built-in)`
	case "windows":
		return `Windows Dependencies:
  - PowerShell (built-in)`
	default:
		return `Dependencies:
  - Unsupported operating system`
	}
}

// ShowVersion displays version information
func ShowVersion(version string) {
	if version == "" {
		version = "development"
	}

	fmt.Printf("ccopy version %s\n", version)
	fmt.Printf("Built for %s/%s\n", runtime.GOOS, runtime.GOARCH)
	fmt.Printf("Go version: %s\n", runtime.Version())
}

// ShowError displays an error message with helpful context
func ShowError(err error) {
	fmt.Printf("Error: %v\n\n", err)
	fmt.Println("For help, run: ccopy")
	fmt.Println("For dependencies, check: ccopy --help")
}
