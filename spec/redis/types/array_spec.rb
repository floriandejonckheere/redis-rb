# frozen_string_literal: true

RSpec.describe Redis::Types::Array do
  subject(:type) { build(:array, elements:) }

  let(:elements) { [build(:simple_string, message: "one"), build(:simple_string, message: "two")] }

  let(:pipes) { IO.pipe }

  let(:rsocket) { pipes.first }
  let(:wsocket) { pipes.last }

  describe "#to_s" do
    it "serializes the type" do
      expect(type.to_s).to eq "*2\r\n+one\r\n+two\r\n"
    end
  end

  describe ".parse" do
    it "parses the type" do
      wsocket.write("2\r\n+one\r\n+two\r\n")

      type = described_class.parse(rsocket)

      one, two = type.elements

      expect(one).to be_a Redis::Types::SimpleString
      expect(one.message).to eq "one"

      expect(two).to be_a Redis::Types::SimpleString
      expect(two.message).to eq "two"
    end
  end
end
