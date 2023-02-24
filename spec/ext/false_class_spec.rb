# frozen_string_literal: true

RSpec.describe FalseClass do
  subject(:type) { value }

  let(:value) { false }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Redis::Types::Parser.new(rsocket) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "#f\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      wsocket.write("f\r\n")

      type = described_class.from_resp3("#", rsocket) { parser.read }

      expect(type).to be false
    end
  end
end
