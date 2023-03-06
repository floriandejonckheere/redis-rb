# frozen_string_literal: true

RSpec.describe FalseClass do
  subject(:type) { value }

  let(:value) { false }

  let(:pipes) { IO.pipe }

  let(:read_connection) { Rediss::Connection.new(pipes.first) }
  let(:write_connection) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(read_connection) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "#f\r\n"
    end
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "false"
    end

    context "when the indent is non-zero" do
      it "pretty prints the type" do
        expect(type.to_pretty_s(indent: 2)).to eq "false"
      end
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      write_connection.write("f\r\n")

      type = described_class.from_resp3("#", read_connection) { parser.read }

      expect(type).to be false
    end
  end
end
