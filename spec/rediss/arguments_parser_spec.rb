# frozen_string_literal: true

RSpec.describe Rediss::ArgumentsParser do
  let(:parser) { described_class.new(definitions) }

  let(:definitions) do
    [
      Rediss::Arguments::Key.new(:key, key_spec_index: 0),
      Rediss::Arguments::String.new(:value, flags: [:optional]),
    ]
  end

  describe "arity" do
    context "when fewer than required arguments are specified" do
      it "raises an error" do
        expect { parser.parse([]) }.to raise_error ArgumentError
      end
    end

    context "when only required arguments are specified" do
      it "does not raise" do
        expect { parser.parse(["my_key"]) }.not_to raise_error
      end
    end

    context "when more than allowed arguments are specified" do
      it "raises an error" do
        expect { parser.parse(["my_key", "my_value", "another_value"]) }.to raise_error ArgumentError
      end
    end
  end

  describe "key arguments" do
    let(:definitions) { [Rediss::Arguments::Key.new(:key, key_spec_index: 0)] }

    it "parses arguments" do
      expect(parser.parse(["my_key"])).to eq key: "my_key"
    end
  end

  describe "string arguments" do
    let(:definitions) { [Rediss::Arguments::String.new(:a_string), Rediss::Arguments::String.new(:another_string, flags: [:optional])] }

    it "parses required arguments" do
      expect(parser.parse(["my_string"])).to eq a_string: "my_string"
    end

    it "parses optional arguments" do
      expect(parser.parse(["my_string", "another_string"])).to include another_string: "another_string"
    end
  end

  describe "integer arguments"

  describe "double arguments"

  describe "pattern arguments"

  describe "unix-time arguments"

  describe "pure-token arguments"

  describe "oneof arguments"

  describe "block arguments"
end
