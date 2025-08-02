# frozen_string_literal: true

RSpec.describe Ccopy do
  it "has a version number" do
    expect(Ccopy::VERSION).not_to be nil
  end

  it "output help message when no parameters are given" do
    expect { Ccopy::Main.call }.to output(/Usage/).to_stdout
  end
end
