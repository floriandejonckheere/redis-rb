# frozen_string_literal: true

RSpec.describe Float do
  subject(:type) { value }

  let(:value) { 1.23 }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq ",1.23\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      wsocket.write("1.23\r\n")

      type = described_class.from_resp3(",", rsocket)

      expect(type).to eq 1.23
    end
  end
end
