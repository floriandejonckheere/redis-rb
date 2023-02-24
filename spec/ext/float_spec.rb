# frozen_string_literal: true

RSpec.describe Float do
  subject(:type) { value }

  let(:value) { 1.23 }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Redis::Types::Parser.new(rsocket) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq ",1.23\r\n"
    end

    context "when the value is not a number" do
      let(:value) { Float::NAN }

      it "serializes the type" do
        expect(value.to_resp3).to eq ",nan\r\n"
      end
    end
  end

  context "when the value is infinity" do
    let(:value) { Float::INFINITY }

    it "serializes the type" do
      expect(type.to_resp3).to eq ",inf\r\n"
    end
  end

  context "when the value is negative infinity" do
    let(:value) { -Float::INFINITY }

    it "serializes the type" do
      expect(value.to_resp3).to eq ",-inf\r\n"
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      wsocket.write("1.23\r\n")

      type = described_class.from_resp3(",", rsocket) { parser.read }

      expect(type).to eq 1.23
    end

    context "when the value is not a number" do
      it "deserializes the type" do
        wsocket.write("nan\r\n")

        type = described_class.from_resp3(",", rsocket) { parser.read }

        expect(type).to be_nan
      end
    end

    context "when the value is infinity" do
      it "deserializes the type" do
        wsocket.write("inf\r\n")

        type = described_class.from_resp3(",", rsocket) { parser.read }

        expect(type).to be_infinite
      end
    end

    context "when the value is negative infinity" do
      it "deserializes the type" do
        wsocket.write("-inf\r\n")

        type = described_class.from_resp3(",", rsocket) { parser.read }

        expect(type).to be_infinite
      end
    end
  end
end
