# frozen_string_literal: true

require_relative "ccopy/version"
require 'rbconfig'

module Ccopy
  class Error < StandardError; end

  class Main
    def self.call(*args)
      @debug = args.include?("--debug")

      if args.include?("-h") || args.include?("--help") || $stdin.tty?
        show_help
        return
      end

      input = $stdin.read
      copy_to_clipboard(input)
      puts "Copied to clipboard!"
    end

    def self.copy_to_clipboard(text)
      debug_puts "Text to be copied: #{text.inspect}"
      debug_puts "Host OS: #{RbConfig::CONFIG["host_os"]}"

      case RbConfig::CONFIG["host_os"]
      when /darwin/
        debug_puts "Using pbcopy for macOS"
        IO.popen("pbcopy", "w") do |io|
          io.write(text)
          debug_puts "written in pipe"
        end
        debug_puts "pbcopy executed successfully"
      when /linux/
        debug_puts "Using xclip for Linux"
        IO.popen("xclip -selection clipboard", "w") { |io| io.write(text) }
        debug_puts "xclip executed successfully"
      end
    rescue StandardError => e
      puts "Error copying to clipboard: #{e}"
      if @debug
        puts "Error class: #{e.class}"
        puts "Error backtrace: #{e.backtrace.join("\n")}"
      end
    end

    private

    def self.show_help
      puts "ccopy - Copy stdin to clipboard"
      puts ""
      puts "Usage:"
      puts "  <command> | ccopy [options]"
      puts ""
      puts "Examples:"
      puts "  cat file.txt | ccopy"
      puts "  ls -la | ccopy"
      puts "  echo 'hello world' | ccopy --debug"
      puts "  curl -s api.example.com/data | ccopy"
      puts ""
      puts "Options:"
      puts "  -h, --help     Show this help message"
      puts "      --debug    Show debug information"
      puts ""
      puts "Description:"
      puts "  ccopy reads from stdin and copies the content to the system clipboard."
      puts "  Works on macOS (pbcopy) and Linux (xclip)."
    end

    def self.debug_puts(message)
      puts "Debug: #{message}" if @debug
    end
  end
end
