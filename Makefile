# Makefile para ccopy

BINARY_NAME=ccopy
VERSION=1.0.0

.PHONY: build install clean test release

# Local Build
build:
	go build -ldflags "-X main.Version=$(VERSION)" -o $(BINARY_NAME) .

# Build for all platforms
build-all:
	# Linux
	GOOS=linux GOARCH=amd64 go build -ldflags "-X main.Version=$(VERSION)" -o dist/$(BINARY_NAME)-linux-amd64 .
	GOOS=linux GOARCH=arm64 go build -ldflags "-X main.Version=$(VERSION)" -o dist/$(BINARY_NAME)-linux-arm64 .
	# macOS
	GOOS=darwin GOARCH=amd64 go build -ldflags "-X main.Version=$(VERSION)" -o dist/$(BINARY_NAME)-macos-amd64 .
	GOOS=darwin GOARCH=arm64 go build -ldflags "-X main.Version=$(VERSION)" -o dist/$(BINARY_NAME)-macos-arm64 .
	# Windows
	GOOS=windows GOARCH=amd64 go build -ldflags "-X main.Version=$(VERSION)" -o dist/$(BINARY_NAME)-windows-amd64.exe .

# local install for linux and macOS
install: build
	sudo cp $(BINARY_NAME) /usr/local/bin/
	sudo chmod +x /usr/local/bin/$(BINARY_NAME)

# Install only for current user
install-user: build
	mkdir -p ~/.local/bin
	cp $(BINARY_NAME) ~/.local/bin/
	chmod +x ~/.local/bin/$(BINARY_NAME)
	@echo "Certifique-se de que ~/.local/bin está no seu PATH"

uninstall:
	sudo rm -f /usr/local/bin/$(BINARY_NAME)
	rm -f ~/.local/bin/$(BINARY_NAME)

test:
	go test ./...

clean:
	rm -f $(BINARY_NAME)
	rm -rf dist/

# Make release package
release: clean build-all
	mkdir -p release
	tar -czf release/$(BINARY_NAME)-$(VERSION)-linux-amd64.tar.gz -C dist $(BINARY_NAME)-linux-amd64
	tar -czf release/$(BINARY_NAME)-$(VERSION)-linux-arm64.tar.gz -C dist $(BINARY_NAME)-linux-arm64
	tar -czf release/$(BINARY_NAME)-$(VERSION)-macos-amd64.tar.gz -C dist $(BINARY_NAME)-macos-amd64
	tar -czf release/$(BINARY_NAME)-$(VERSION)-macos-arm64.tar.gz -C dist $(BINARY_NAME)-macos-arm64
	zip -j release/$(BINARY_NAME)-$(VERSION)-windows-amd64.zip dist/$(BINARY_NAME)-windows-amd64.exe

# Install dependencies for ubuntu/debian
install-deps:
	sudo apt update
	sudo apt install -y xclip

# Dependencies for Fedora
install-deps-fedora:
	sudo dnf install -y xclip

# Dependencies for Arch Linux
install-deps-arch:
	sudo pacman -S xclip
