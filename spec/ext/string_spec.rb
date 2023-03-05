# frozen_string_literal: true

RSpec.describe String do
  subject(:type) { described_class.new(value) }

  let(:value) { "hello world" }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(rsocket) }

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
      wsocket.write("11\r\nhello world\r\n")

      type = described_class.from_resp3("$", rsocket) { parser.read }

      expect(type).to eq "hello world"
    end

    it "deserializes simple strings" do
      wsocket.write("hello world\r\n")

      type = described_class.from_resp3("+", rsocket) { parser.read }

      expect(type).to eq "hello world"
    end

    it "deserializes verbatim strings" do
      wsocket.write("15\r\ntxt:hello world\r\n")

      type = described_class.from_resp3("=", rsocket) { parser.read }

      expect(type).to eq "hello world"
    end
  end
end
