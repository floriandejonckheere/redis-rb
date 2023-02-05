# frozen_string_literal: true

RSpec.describe Redis::Types::Parser do
  subject(:parser) { described_class.new(rsocket) }

  let(:pipes) { IO.pipe }

  let(:rsocket) { pipes.first }
  let(:wsocket) { pipes.last }

  describe "#read" do
    it "parses simple error strings" do
      wsocket.write("+hello world\r\n")

      expect(parser.read).to be_a Redis::Types::SimpleString
    end

    it "parses simple error types" do
      wsocket.write("-ERR unknown command 'X'\r\n")

      expect(parser.read).to be_a Redis::Types::SimpleError
    end

    it "returns a simple error for unknown types" do
      wsocket.write("&ERR unknown command 'X'\r\n")

      expect(parser.read).to be_a Redis::Types::SimpleError
    end
  end
end
