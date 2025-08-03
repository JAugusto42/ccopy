# ccopy

A simple, fast, and lightweight CLI tool to copy terminal output to clipboard.

## Features

- 🚀 **Fast**
- 📦 **Lightweight**
- 🔄 **Cross-platform**: Works on Linux and macOS
- 📋 **Simple**: Just pipe any command output to `ccopy`
- 🎯 **Reliable**: Handles large outputs efficiently

## Installation

### Quick Install (Linux or Osx)
   ```bash
   gem install ccopy
   ```

### Build from Source

```bash
git clone https://github.com/JAugusto42/ccopy.git
cd ccopy
gem build ccopy.gemspec
gem install ccopy-version.gem
```

## Usage

Simply pipe any command output to `ccopy`:

```bash
# Copy file contents
cat file.txt | ccopy

# Copy directory listing
ls -la | ccopy

# Copy process list
ps aux | ccopy

# Copy API response
curl -s https://api.github.com/users/octocat | ccopy

# Copy command output
echo "Hello World" | ccopy

# Copy complex command chains
docker ps --format "table {{.Names}}\t{{.Status}}" | ccopy
```

## System Requirements

### Linux
- **xclip** (recommended) or **xsel**
- Install with: `sudo apt install xclip` (Ubuntu/Debian) or `sudo dnf install xclip` (Fedora)

### macOS
- **pbcopy** (built-in)

## Examples

### Development Workflow
```bash
# Copy git log
git log --oneline -10 | ccopy

# Copy current directory structure
tree | ccopy
```

### System Administration
```bash
# Copy system information
uname -a | ccopy

# Copy disk usage
df -h | ccopy

# Copy network configuration
ip addr show | ccopy
```

### File Processing
```bash
# Copy filtered logs
tail -f /var/log/nginx/access.log | grep ERROR | ccopy

# Copy search results
grep -r "TODO" src/ | ccopy
```

## Platform Support

| Platform | Architecture | Status |
|----------|--------------|--------|
| Linux    | amd64        | ✅     |
| Linux    | arm64        | ✅     |
| macOS    | amd64        | ✅     |
| macOS    | arm64        | ✅     |

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Run tests: `rbenv`
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Troubleshooting

### "xclip or xsel not found" Error

**Solution**: Install clipboard utilities:
```bash
# Ubuntu/Debian
sudo apt install xclip

# Fedora/CentOS
sudo dnf install xclip

# Arch Linux
sudo pacman -S xclip
```

### Command Not Found

**Solution**: Ensure the binary is in your PATH:
```bash
# Check if ccopy is in PATH
which ccopy

# Maybe you are using rbenv without set the the correct ruby version or rbenv init in your bashrc or zshrc for example.
```

### Large Output Issues

**Solution**: ccopy handles large outputs efficiently, but for extremely large data:
```bash
# Use with head/tail for large files
head -1000 large_file.txt | ccopy
tail -100 /var/log/system.log | ccopy
```

## FAQ

**Q: Does ccopy work with all shells?**
A: Yes, ccopy works with bash, zsh, fish, and any POSIX-compliant shell.

**Q: Can I copy binary data?**
A: ccopy is designed for text data. Binary data may not clipboard properly.

**Q: How much data can ccopy handle?**
A: ccopy can handle several MB of text data efficiently.

**Q: Does ccopy work over SSH?**
A: Yes, but clipboard integration depends on your terminal and SSH client configuration.

## Alternatives

- `xclip` - X11 clipboard utility
- `xsel` - X selection utility
- `pbcopy` - macOS clipboard utility
- `wl-clipboard` - Wayland clipboard utility

## Changelog

### v1.0.0
- Initial release
- Cross-platform support (linux and macos only)
- Automatic clipboard utility detection
- Error handling and help system
