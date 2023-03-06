# frozen_string_literal: true

RSpec.describe Error do
  subject(:type) { described_class.new(code, value) }

  let(:code) { "ERR" }
  let(:value) { "hello world" }

  let(:pipes) { IO.pipe }

  let(:read_connection) { Rediss::Connection.new(pipes.first) }
  let(:write_connection) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(read_connection) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "!15\r\nERR hello world\r\n"
    end
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "ERR hello world"
    end

    context "when the indent is non-zero" do
      it "pretty prints the type" do
        expect(type.to_pretty_s(indent: 2)).to eq "ERR hello world"
      end
    end
  end

  describe ".from_resp3" do
    it "deserializes blob errors" do
      write_connection.write("15\r\nERR hello world\r\n")

      type = described_class.from_resp3("!", read_connection) { parser.read }

      expect(type.code).to eq "ERR"
      expect(type.message).to eq "hello world"
    end

    it "deserializes simple strings" do
      write_connection.write("ERR hello world\r\n")

      type = described_class.from_resp3("-", read_connection) { parser.read }

      expect(type.code).to eq "ERR"
      expect(type.message).to eq "hello world"
    end

    it "deserializes blob strings" do
      write_connection.write("21\r\nSYNTAX invalid syntax\r\n")

      type = described_class.from_resp3("!", read_connection) { parser.read }

      expect(type.code).to eq "SYNTAX"
      expect(type.message).to eq "invalid syntax"
    end
  end
end
