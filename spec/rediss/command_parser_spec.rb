# frozen_string_literal: true

RSpec.describe Rediss::CommandParser do
  subject(:parser) { described_class.new(arguments) }

  describe "#read" do
    context "HELLO" do
      let(:arguments) { ["HELLO", "3"] }

      it "parses the command" do
        expect(parser.read).to be_a Rediss::Commands::Hello
      end
    end

    context "unknown command" do
      let(:arguments) { ["UNKNOWN"] }

      it "raises" do
        expect { parser.read }.to raise_error ArgumentError
      end
    end
  end
end