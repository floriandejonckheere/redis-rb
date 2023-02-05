# frozen_string_literal: true

RSpec.describe Redis::Types::SimpleError do
  subject(:type) { described_class.new(message) }

  let(:message) { "unknown command 'X'" }

  let(:socket) { StringIO.new }

  describe "#to_s" do
    it "serializes the type" do
      expect(type.to_s).to eq "-ERR unknown command 'X'\r\n"
    end
  end

  describe ".parse" do
    it "parses the type" do
      socket.write("ERR unknown command 'X'\r\n")
      socket.rewind

      type = described_class.parse(socket)

      expect(type.message).to eq "unknown command 'X'"
    end
  end
end