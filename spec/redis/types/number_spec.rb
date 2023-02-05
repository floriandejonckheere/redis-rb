# frozen_string_literal: true

RSpec.describe Redis::Types::Number do
  subject(:type) { build(:number, value:) }

  let(:value) { 1 }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#to_s" do
    it "serializes the type" do
      expect(type.to_s).to eq ":1\r\n"
    end
  end

  describe ".parse" do
    it "parses the type" do
      wsocket.write("1\r\n")

      type = described_class.parse(rsocket)

      expect(type.value).to eq 1
    end
  end
end
