package main

import (
	"fmt"
	"os"
	"strings"

	"ccopy/clipboard"
	"ccopy/help"
	"ccopy/input"
)

var Version = "development"

func main() {
	// Handle command line arguments
	if len(os.Args) > 1 {
		switch os.Args[1] {
		case "-h", "--help":
			help.Show()
			return
		case "-v", "--version":
			help.ShowVersion(Version)
			return
		case "--check":
			checkDependencies()
			return
		}
	}

	// Check if there's data in stdin
	if !input.HasStdinData() {
		help.Show()
		return
	}

	// Read from standard input (stdin)
	data, err := input.ReadStdinString()
	if err != nil {
		help.ShowError(fmt.Errorf("reading input: %v", err))
		os.Exit(1)
	}

	// If no input, show help
	if len(strings.TrimSpace(data)) == 0 {
		help.Show()
		return
	}

	// Copy to clipboard
	if err := clipboard.Copy(data); err != nil {
		help.ShowError(fmt.Errorf("copying to clipboard: %v", err))
		os.Exit(1)
	}

	fmt.Println("✓ Copied to clipboard!")
}

func checkDependencies() {
	fmt.Println("Checking system dependencies...")

	if clipboard.IsAvailable() {
		fmt.Println("✅ Clipboard functionality is available")
	} else {
		fmt.Println("❌ Clipboard functionality is not available")
		deps := clipboard.GetRequiredDependencies()
		fmt.Printf("Required dependencies: %s\n", strings.Join(deps, " or "))
		os.Exit(1)
	}

	fmt.Println("\nSystem information:")
	help.ShowVersion(Version)
}
