# frozen_string_literal: true

RSpec.describe Integer do
  subject(:type) { value }

  let(:value) { 3 }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Rediss::Types::Parser.new(rsocket) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq ":3\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes integers" do
      wsocket.write("3\r\n")

      type = described_class.from_resp3(":", rsocket) { parser.read }

      expect(type).to eq 3
    end

    it "deserializes big numbers" do
      wsocket.write("3492890328409238509324850943850943825024385\r\n")

      type = described_class.from_resp3("(", rsocket) { parser.read }

      expect(type).to eq 3_492_890_328_409_238_509_324_850_943_850_943_825_024_385
    end
  end
end
