# frozen_string_literal: true

RSpec.describe Redis::Types::Parser do
  subject(:parser) { described_class.new(socket) }

  let(:socket) { StringIO.new }

  describe "#read" do
    it "parses simple error types" do
      socket.write("-ERR unknown command 'X'\r\n")

      expect(parser.read).to be_a Redis::Types::SimpleError
    end

    it "returns a simple error for unknown types" do
      socket.write("&ERR unknown command 'X'\r\n")
      socket.rewind

      expect(parser.read).to be_a Redis::Types::SimpleError
    end
  end
end
