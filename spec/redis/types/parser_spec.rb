# frozen_string_literal: true

RSpec.describe Redis::Types::Parser do
  subject(:parser) { described_class.new(rsocket) }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#read" do
    it "parses blob strings" do
      wsocket.write("$11\r\nhello world\r\n")

      expect(parser.read).to be_a Redis::Types::BlobString
    end

    it "parses simple error strings" do
      wsocket.write("+hello world\r\n")

      expect(parser.read).to be_a Redis::Types::SimpleString
    end

    it "parses simple error types" do
      wsocket.write("-ERR unknown command 'X'\r\n")

      expect(parser.read).to be_a Redis::Types::SimpleError
    end

    it "parses numbers" do
      wsocket.write(":1\r\n")

      expect(parser.read).to be_a Redis::Types::Number
    end

    it "parses arrays" do
      wsocket.write("*2\r\n+one\r\n+two\r\n")

      expect(parser.read).to be_a Redis::Types::Array
    end

    it "raises for unknown types" do
      wsocket.write("&ERR unknown command 'X'\r\n")

      expect { parser.read }.to raise_error ArgumentError
    end
  end
end
