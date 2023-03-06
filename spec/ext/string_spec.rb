# frozen_string_literal: true

RSpec.describe String do
  subject(:type) { described_class.new(value) }

  let(:value) { "hello world" }

  let(:parser) { Rediss::TypeParser.new(default_connection) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "$11\r\nhello world\r\n"
    end
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "\"hello world\""
    end

    context "when the indent is non-zero" do
      it "pretty prints the type" do
        expect(type.to_pretty_s(indent: 2)).to eq "\"hello world\""
      end
    end
  end

  describe ".from_resp3" do
    it "deserializes blob strings" do
      io.write("11\r\nhello world\r\n")
      io.rewind

      type = described_class.from_resp3("$", default_connection) { parser.read }

      expect(type).to eq "hello world"
    end

    it "deserializes simple strings" do
      io.write("hello world\r\n")
      io.rewind

      type = described_class.from_resp3("+", default_connection) { parser.read }

      expect(type).to eq "hello world"
    end

    it "deserializes verbatim strings" do
      io.write("15\r\ntxt:hello world\r\n")
      io.rewind

      type = described_class.from_resp3("=", default_connection) { parser.read }

      expect(type).to eq "hello world"
    end
  end
end
