# frozen_string_literal: true

RSpec.describe Redis::Types::SimpleString do
  subject(:type) { described_class.new(message) }

  let(:message) { "hello world" }

  let(:socket) { StringIO.new }

  describe "#to_s" do
    it "serializes the type" do
      expect(type.to_s).to eq "+hello world\r\n"
    end
  end

  describe ".parse" do
    it "parses the type" do
      socket.write("hello world\r\n")
      socket.rewind

      type = described_class.parse(socket)

      expect(type.message).to eq "hello world"
    end
  end
end
