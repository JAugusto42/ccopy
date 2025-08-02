# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ccopy do
  it "has a version number" do
    expect(Ccopy::VERSION).not_to be nil
  end

  it "output help message when no parameters are given" do
    expect { Ccopy::Main.call }.to output(/Usage/).to_stdout
  end

  it "shows help when --help flag is used" do
    expect { Ccopy::Main.call("--help") }.to output(/Usage/).to_stdout
  end

  it "shows debug info when --debug flag is used" do
    allow($stdin).to receive(:tty?).and_return(false)
    allow($stdin).to receive(:read).and_return("test")
    expect { Ccopy::Main.call("--debug") }.to output(/Debug/).to_stdout
  end
end
