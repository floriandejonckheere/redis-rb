# frozen_string_literal: true

RSpec.describe NilClass do
  subject(:type) { value }

  let(:value) { nil }

  let(:parser) { Rediss::TypeParser.new(default_connection) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "_\r\n"
    end
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "(nil)"
    end

    context "when the indent is non-zero" do
      it "pretty prints the type" do
        expect(type.to_pretty_s(indent: 2)).to eq "(nil)"
      end
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      io.write("\r\n")
      io.rewind

      type = described_class.from_resp3("_", default_connection) { parser.read }

      expect(type).to be_nil
    end
  end
end
