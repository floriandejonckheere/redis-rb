# frozen_string_literal: true

RSpec.describe NilClass do
  subject(:type) { value }

  let(:value) { nil }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Rediss::Types::Parser.new(rsocket) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "_\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      wsocket.write("\r\n")

      type = described_class.from_resp3("_", rsocket) { parser.read }

      expect(type).to be_nil
    end
  end
end
