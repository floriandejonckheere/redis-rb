# frozen_string_literal: true

RSpec.describe Rediss::CommandParser do
  subject(:parser) { described_class.new(arguments, default_connection) }

  describe "#read" do
    context "when the command is known" do
      let(:arguments) { ["HELLO", "3"] }

      it "parses the command" do
        expect(parser.read).to be_a Rediss::Commands::Hello
      end
    end

    context "when the command is unknown" do
      let(:arguments) { ["UNKNOWN"] }

      it "raises" do
        expect { parser.read }.to raise_error ArgumentError
      end
    end
  end
end
