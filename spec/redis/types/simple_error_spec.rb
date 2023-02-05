# frozen_string_literal: true

RSpec.describe Redis::Types::SimpleError do
  subject(:type) { described_class.new(message) }

  let(:message) { "unknown command 'X'" }

  let(:socket) { instance_double("TCPSocket") }

  describe "#to_s" do
    it "serializes the type" do
      expect(type.to_s).to eq "-ERR unknown command 'X'\r\n"
    end
  end

  describe ".parse" do
    it "parses the type" do
      allow(socket).to receive(:readline).and_return("ERR unknown command 'X'\r\n")

      type = described_class.parse(socket)

      expect(type.message).to eq "unknown command 'X'"
    end
  end
end
