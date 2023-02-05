# frozen_string_literal: true

RSpec.describe Redis::Types::SimpleError do
  subject(:type) { build(:simple_error, message:) }

  let(:message) { "unknown command 'X'" }

  let(:pipes) { IO.pipe }

  let(:rsocket) { pipes.first }
  let(:wsocket) { pipes.last }

  describe "#to_s" do
    it "serializes the type" do
      expect(type.to_s).to eq "-ERR unknown command 'X'\r\n"
    end
  end

  describe ".parse" do
    it "parses the type" do
      wsocket.write("ERR unknown command 'X'\r\n")

      type = described_class.parse(rsocket)

      expect(type.message).to eq "unknown command 'X'"
    end
  end
end
