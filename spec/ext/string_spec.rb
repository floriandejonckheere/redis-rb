# frozen_string_literal: true

RSpec.describe String do
  subject(:type) { described_class.new(value) }

  let(:value) { "hello world" }

  let(:pipes) { IO.pipe }

  let(:read_connection) { Rediss::Connection.new(pipes.first) }
  let(:write_connection) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(read_connection) }

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
      write_connection.write("11\r\nhello world\r\n")

      type = described_class.from_resp3("$", read_connection) { parser.read }

      expect(type).to eq "hello world"
    end

    it "deserializes simple strings" do
      write_connection.write("hello world\r\n")

      type = described_class.from_resp3("+", read_connection) { parser.read }

      expect(type).to eq "hello world"
    end

    it "deserializes verbatim strings" do
      write_connection.write("15\r\ntxt:hello world\r\n")

      type = described_class.from_resp3("=", read_connection) { parser.read }

      expect(type).to eq "hello world"
    end
  end
end
