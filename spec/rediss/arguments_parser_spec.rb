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
    it "parses arguments"
  end

  describe "string arguments" do
    it "parses required arguments"

    it "parses optional arguments"
  end

  describe "integer arguments"

  describe "double arguments"

  describe "pattern arguments"

  describe "unix-time arguments"

  describe "pure-token arguments"

  describe "oneof arguments"

  describe "block arguments"
end
