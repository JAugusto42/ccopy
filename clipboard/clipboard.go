package clipboard

import (
	"fmt"
	"os/exec"
	"runtime"
)

func Copy(text string) error {
	var cmd *exec.Cmd

	switch runtime.GOOS {
	case "linux":
		// Try xclip first, then xsel
		if _, err := exec.LookPath("xclip"); err == nil {
			cmd = exec.Command("xclip", "-selection", "clipboard")
		} else if _, err := exec.LookPath("xsel"); err == nil {
			cmd = exec.Command("xsel", "--clipboard", "--input")
		} else {
			return fmt.Errorf("xclip or xsel not found. Install one of them:\n" +
				"Ubuntu/Debian: sudo apt install xclip\n" +
				"Fedora: sudo dnf install xclip\n" +
				"Arch: sudo pacman -S xclip")
		}
	case "darwin":
		cmd = exec.Command("pbcopy")
	case "windows":
		cmd = exec.Command("powershell", "-command", "Set-Clipboard")
	default:
		return fmt.Errorf("unsupported operating system: %s", runtime.GOOS)
	}

	stdin, err := cmd.StdinPipe()
	if err != nil {
		return err
	}

	if err := cmd.Start(); err != nil {
		return err
	}

	if _, err := stdin.Write([]byte(text)); err != nil {
		stdin.Close()
		return err
	}

	if err := stdin.Close(); err != nil {
		return err
	}

	return cmd.Wait()
}

func IsAvailable() bool {
	switch runtime.GOOS {
	case "linux":
		_, xclipErr := exec.LookPath("xclip")
		_, xselErr := exec.LookPath("xsel")
		return xclipErr == nil || xselErr == nil
	case "darwin":
		_, err := exec.LookPath("pbcopy")
		return err == nil
	case "windows":
		_, err := exec.LookPath("powershell")
		return err == nil
	default:
		return false
	}
}

func GetRequiredDependencies() []string {
	switch runtime.GOOS {
	case "linux":
		return []string{"xclip", "xsel"}
	case "darwin":
		return []string{"pbcopy (built-in)"}
	case "windows":
		return []string{"PowerShell (built-in)"}
	default:
		return []string{"unsupported"}
	}
}
