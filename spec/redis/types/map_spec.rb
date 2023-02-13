# frozen_string_literal: true

RSpec.describe Redis::Types::Map do
  subject(:type) { build(:map, value:) }

  let(:value) { { build(:simple_string, value: "one") => build(:simple_string, value: "two") } }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#to_s" do
    it "serializes the type" do
      expect(type.to_s).to eq "%2\r\n+one\r\n+two\r\n"
    end
  end

  describe ".parse" do
    it "parses the type" do
      wsocket.write("2\r\n+one\r\n+two\r\n")

      type = described_class.parse(rsocket)

      hash = type.value

      one = hash.keys.first
      expect(one).to be_a Redis::Types::SimpleString
      expect(one.value).to eq "one"

      two = hash.values.first
      expect(two).to be_a Redis::Types::SimpleString
      expect(two.value).to eq "two"

      expect(hash[one]).to eq two
    end
  end
end
