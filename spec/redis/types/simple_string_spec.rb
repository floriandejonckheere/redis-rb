# frozen_string_literal: true

RSpec.describe Redis::Types::SimpleString do
  subject(:type) { build(:simple_string, value:) }

  let(:value) { "hello world" }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#to_s" do
    it "serializes the type" do
      expect(type.to_s).to eq "+hello world\r\n"
    end
  end

  describe ".parse" do
    it "parses the type" do
      wsocket.write("hello world\r\n")

      type = described_class.parse(rsocket)

      expect(type.value).to eq "hello world"
    end
  end
end
