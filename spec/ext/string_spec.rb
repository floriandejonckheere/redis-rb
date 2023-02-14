# frozen_string_literal: true
# typed: true

RSpec.describe String do
  subject(:type) { described_class.new(value) }

  let(:value) { "hello world" }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "$11\r\nhello world\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes blob strings" do
      wsocket.write("$11\r\nhello world\r\n")

      type = described_class.from_resp3(rsocket)

      expect(type).to eq "hello world"
    end

    it "deserializes simple strings" do
      wsocket.write("+hello world\r\n")

      type = described_class.from_resp3(rsocket)

      expect(type).to eq "hello world"
    end
  end
end
