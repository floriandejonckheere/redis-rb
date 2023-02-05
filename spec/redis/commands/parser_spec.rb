# frozen_string_literal: true

RSpec.describe Redis::Commands::Parser do
  subject(:parser) { described_class.new(arguments) }

  describe "#read" do
    context "HELLO" do
      let(:arguments) { build(:array, value: [build(:simple_string, value: "HELLO"), build(:number, value: 3)]) }

      it "parses the command" do
        expect(parser.read).to be_a Redis::Commands::Hello
      end
    end

    context "unknown command" do
      let(:arguments) { build(:array, value: [build(:simple_string, value: "UNKNOWN")]) }

      it "raises" do
        expect { parser.read }.to raise_error ArgumentError
      end
    end
  end
end
