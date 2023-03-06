# frozen_string_literal: true

RSpec.describe Integer do
  subject(:type) { value }

  let(:value) { 3 }

  let(:pipes) { IO.pipe }

  let(:read_connection) { Rediss::Connection.new(pipes.first) }
  let(:write_connection) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(read_connection) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq ":3\r\n"
    end
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "(integer) 3"
    end

    context "when the indent is non-zero" do
      it "pretty prints the type" do
        expect(type.to_pretty_s(indent: 2)).to eq "(integer) 3"
      end
    end
  end

  describe ".from_resp3" do
    it "deserializes integers" do
      write_connection.write("3\r\n")

      type = described_class.from_resp3(":", read_connection) { parser.read }

      expect(type).to eq 3
    end

    it "deserializes big numbers" do
      write_connection.write("3492890328409238509324850943850943825024385\r\n")

      type = described_class.from_resp3("(", read_connection) { parser.read }

      expect(type).to eq 3_492_890_328_409_238_509_324_850_943_850_943_825_024_385
    end
  end
end
