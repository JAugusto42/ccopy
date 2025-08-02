# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ccopy do
  it "has a version number" do
    expect(Ccopy::VERSION).not_to be nil
  end

  describe Ccopy::Main do
    describe ".call" do
      it "output help message when no parameters are given" do
        # Mock stdin.tty? to return true (simulating terminal input)
        allow($stdin).to receive(:tty?).and_return(true)

        expect { Ccopy::Main.call }.to output(/Usage/).to_stdout
      end

      it "shows help when --help flag is used" do
        expect { Ccopy::Main.call("--help") }.to output(/Usage/).to_stdout
      end

      context "on macOS" do
        before do
          allow(RbConfig::CONFIG).to receive(:[]).with("host_os").and_return("darwin24")
        end

        it "shows debug info when --debug flag is used" do
          # Mock stdin to simulate piped input
          allow($stdin).to receive(:tty?).and_return(false)
          allow($stdin).to receive(:read).and_return("test")

          # Mock IO.popen to avoid real system calls
          allow(IO).to receive(:popen).with("pbcopy", "w").and_yield(double("io", write: nil))

          expect { Ccopy::Main.call("--debug") }.to output(/Debug/).to_stdout
        end

        it "copies stdin to clipboard when input is piped" do
          # Mock stdin to simulate piped input
          allow($stdin).to receive(:tty?).and_return(false)
          allow($stdin).to receive(:read).and_return("test content")

          # Mock IO.popen to avoid real system calls
          io_mock = double("io")
          expect(io_mock).to receive(:write).with("test content")
          allow(IO).to receive(:popen).with("pbcopy", "w").and_yield(io_mock)

          expect { Ccopy::Main.call }.to output(/Copied to clipboard!/).to_stdout
        end

        it "handles clipboard errors gracefully" do
          # Mock stdin to simulate piped input
          allow($stdin).to receive(:tty?).and_return(false)
          allow($stdin).to receive(:read).and_return("test")

          # Mock IO.popen to raise an error
          allow(IO).to receive(:popen).with("pbcopy", "w").and_raise(StandardError.new("Clipboard error"))

          expect { Ccopy::Main.call }.to output(/Error copying to clipboard: Clipboard error/).to_stdout
        end
      end

      context "on Linux" do
        before do
          allow(RbConfig::CONFIG).to receive(:[]).with("host_os").and_return("linux-gnu")
        end

        it "shows debug info when --debug flag is used" do
          # Mock stdin to simulate piped input
          allow($stdin).to receive(:tty?).and_return(false)
          allow($stdin).to receive(:read).and_return("test")

          # Mock IO.popen to avoid real system calls
          allow(IO).to receive(:popen).with("xclip -selection clipboard", "w").and_yield(double("io", write: nil))

          expect { Ccopy::Main.call("--debug") }.to output(/Debug/).to_stdout
        end

        it "copies stdin to clipboard when input is piped" do
          # Mock stdin to simulate piped input
          allow($stdin).to receive(:tty?).and_return(false)
          allow($stdin).to receive(:read).and_return("test content")

          # Mock IO.popen to avoid real system calls
          io_mock = double("io")
          expect(io_mock).to receive(:write).with("test content")
          allow(IO).to receive(:popen).with("xclip -selection clipboard", "w").and_yield(io_mock)

          expect { Ccopy::Main.call }.to output(/Copied to clipboard!/).to_stdout
        end

        it "handles clipboard errors gracefully" do
          # Mock stdin to simulate piped input
          allow($stdin).to receive(:tty?).and_return(false)
          allow($stdin).to receive(:read).and_return("test")

          # Mock IO.popen to raise an error
          allow(IO).to receive(:popen).with("xclip -selection clipboard", "w").and_raise(StandardError.new("Clipboard error"))

          expect { Ccopy::Main.call }.to output(/Error copying to clipboard: Clipboard error/).to_stdout
        end
      end
    end
  end
end
