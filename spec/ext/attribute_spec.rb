# frozen_string_literal: true

RSpec.describe Attribute do
  subject(:type) { described_class[value] }

  let(:value) { { "hello" => "world" } }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(rsocket) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "|2\r\n$5\r\nhello\r\n$5\r\nworld\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      wsocket.write("2\r\n$5\r\nhello\r\n$5\r\nworld\r\n")

      type = described_class.from_resp3("|", rsocket) { parser.read }

      expect(type).to eq(described_class[{ "hello" => "world" }])
    end
  end
end
