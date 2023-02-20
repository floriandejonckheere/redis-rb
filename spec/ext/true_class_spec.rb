# frozen_string_literal: true

RSpec.describe TrueClass do
  subject(:type) { value }

  let(:value) { true }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "#t\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      wsocket.write("t\r\n")

      type = described_class.from_resp3("#", rsocket)

      expect(type).to be true
    end
  end
end
