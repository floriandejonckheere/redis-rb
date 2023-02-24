# frozen_string_literal: true

RSpec.describe Error do
  subject(:type) { described_class.new(code, value) }

  let(:code) { "ERR" }
  let(:value) { "hello world" }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Rediss::Types::Parser.new(rsocket) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "!15\r\nERR hello world\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes blob errors" do
      wsocket.write("15\r\nERR hello world\r\n")

      type = described_class.from_resp3("!", rsocket) { parser.read }

      expect(type.code).to eq "ERR"
      expect(type.message).to eq "hello world"
    end

    it "deserializes simple strings" do
      wsocket.write("ERR hello world\r\n")

      type = described_class.from_resp3("-", rsocket) { parser.read }

      expect(type.code).to eq "ERR"
      expect(type.message).to eq "hello world"
    end

    it "deserializes blob strings" do
      wsocket.write("21\r\nSYNTAX invalid syntax\r\n")

      type = described_class.from_resp3("!", rsocket) { parser.read }

      expect(type.code).to eq "SYNTAX"
      expect(type.message).to eq "invalid syntax"
    end
  end
end
