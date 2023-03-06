# frozen_string_literal: true

RSpec.describe Symbol do
  subject(:type) { value }

  let(:value) { :hello_world }

  let(:parser) { Rediss::TypeParser.new(default_connection) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "$11\r\nhello_world\r\n"
    end
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "\"hello_world\""
    end

    context "when the indent is non-zero" do
      it "pretty prints the type" do
        expect(type.to_pretty_s(indent: 2)).to eq "\"hello_world\""
      end
    end
  end

  describe ".from_resp3" do
    it "raises an error" do
      expect { described_class.from_resp3("$", default_connection) { parser.read } }.to raise_error(ArgumentError, "cannot deserialize symbols")
    end
  end
end
