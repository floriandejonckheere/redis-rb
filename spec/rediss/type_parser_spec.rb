# frozen_string_literal: true

RSpec.describe Rediss::TypeParser do
  subject(:parser) { described_class.new(default_connection) }

  describe "#read" do
    it "raises for unknown types" do
      io.write("&ERR unknown command 'X'\r\n")
      io.rewind

      expect { parser.read }.to raise_error ArgumentError
    end

    describe "simple types" do
      it "parses blob strings" do
        io.write("$11\r\nhello world\r\n")
        io.rewind

        expect(parser.read).to be_a String
      end

      it "parses simple strings" do
        io.write("+hello world\r\n")
        io.rewind

        expect(parser.read).to be_a String
      end

      it "parses simple errors" do
        io.write("-ERR unknown command 'X'\r\n")
        io.rewind

        expect(parser.read).to be_an Error
      end

      it "parses numbers" do
        io.write(":1\r\n")
        io.rewind

        expect(parser.read).to be_an Integer
      end

      it "parses nulls" do
        io.write("_\r\n")
        io.rewind

        expect(parser.read).to be_nil
      end

      it "parses doubles" do
        io.write(",1.23\r\n")
        io.rewind

        expect(parser.read).to be_a Float
      end

      it "parses booleans" do
        io.write("#t\r\n")
        io.rewind

        expect(parser.read).to be true
      end

      it "parses blob errors" do
        io.write("!21\r\nSYNTAX invalid syntax\r\n")
        io.rewind

        expect(parser.read).to be_an Error
      end

      it "parses verbatim strings" do
        io.write("=15\r\ntxt:Some string\r\n")
        io.rewind

        expect(parser.read).to be_a String
      end

      it "parses big decimals" do
        io.write("(3492890328409238509324850943850943825024385\r\n")
        io.rewind

        expect(parser.read).to be_a Integer
      end
    end

    describe "aggregate types" do
      it "parses arrays" do
        io.write("*2\r\n+one\r\n+two\r\n")
        io.rewind

        expect(parser.read).to be_an Array
      end

      it "parses maps" do
        io.write("%2\r\n+one\r\n+two\r\n")
        io.rewind

        expect(parser.read).to be_a Hash
      end

      it "parses sets" do
        io.write("~2\r\n+one\r\n+two\r\n")
        io.rewind

        expect(parser.read).to be_a Set
      end

      it "parses attributes" do
        io.write("|2\r\n+one\r\n+two\r\n")
        io.rewind

        expect(parser.read).to be_an Attribute
      end
    end
  end
end
