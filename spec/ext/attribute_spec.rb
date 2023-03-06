# frozen_string_literal: true

RSpec.describe Attribute do
  subject(:type) { described_class[value] }

  let(:value) { { "hello" => "world" } }

  let(:pipes) { IO.pipe }

  let(:read_connection) { Rediss::Connection.new(pipes.first) }
  let(:write_connection) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(read_connection) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "|2\r\n$5\r\nhello\r\n$5\r\nworld\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      write_connection.write("2\r\n$5\r\nhello\r\n$5\r\nworld\r\n")

      type = described_class.from_resp3("|", read_connection) { parser.read }

      expect(type).to eq(described_class[{ "hello" => "world" }])
    end
  end
end
