# frozen_string_literal: true

RSpec.describe Float do
  subject(:type) { value }

  let(:value) { 1.23 }

  let(:pipes) { IO.pipe }

  let(:read_connection) { Rediss::Connection.new(pipes.first) }
  let(:write_connection) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(read_connection) }

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
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "(float) 1.23"
    end

    context "when the indent is non-zero" do
      it "pretty prints the type" do
        expect(type.to_pretty_s(indent: 2)).to eq "(float) 1.23"
      end
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      write_connection.write("1.23\r\n")

      type = described_class.from_resp3(",", read_connection) { parser.read }

      expect(type).to eq 1.23
    end

    context "when the value is not a number" do
      it "deserializes the type" do
        write_connection.write("nan\r\n")

        type = described_class.from_resp3(",", read_connection) { parser.read }

        expect(type).to be_nan
      end
    end

    context "when the value is infinity" do
      it "deserializes the type" do
        write_connection.write("inf\r\n")

        type = described_class.from_resp3(",", read_connection) { parser.read }

        expect(type).to be_infinite
      end
    end

    context "when the value is negative infinity" do
      it "deserializes the type" do
        write_connection.write("-inf\r\n")

        type = described_class.from_resp3(",", read_connection) { parser.read }

        expect(type).to be_infinite
      end
    end
  end
end
