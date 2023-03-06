# frozen_string_literal: true

RSpec.describe Rediss::TypeParser do
  subject(:parser) { described_class.new(read_connection) }

  let(:pipes) { IO.pipe }

  let(:read_connection) { Rediss::Connection.new(pipes.first) }
  let(:write_connection) { pipes.last }

  describe "#read" do
    it "raises for unknown types" do
      write_connection.write("&ERR unknown command 'X'\r\n")

      expect { parser.read }.to raise_error ArgumentError
    end

    describe "simple types" do
      it "parses blob strings" do
        write_connection.write("$11\r\nhello world\r\n")

        expect(parser.read).to be_a String
      end

      it "parses simple strings" do
        write_connection.write("+hello world\r\n")

        expect(parser.read).to be_a String
      end

      it "parses simple errors" do
        write_connection.write("-ERR unknown command 'X'\r\n")

        expect(parser.read).to be_an Error
      end

      it "parses numbers" do
        write_connection.write(":1\r\n")

        expect(parser.read).to be_an Integer
      end

      it "parses nulls" do
        write_connection.write("_\r\n")

        expect(parser.read).to be_nil
      end

      it "parses doubles" do
        write_connection.write(",1.23\r\n")

        expect(parser.read).to be_a Float
      end

      it "parses booleans" do
        write_connection.write("#t\r\n")

        expect(parser.read).to be true
      end

      it "parses blob errors" do
        write_connection.write("!21\r\nSYNTAX invalid syntax\r\n")

        expect(parser.read).to be_an Error
      end

      it "parses verbatim strings" do
        write_connection.write("=15\r\ntxt:Some string\r\n")

        expect(parser.read).to be_a String
      end

      it "parses big decimals" do
        write_connection.write("(3492890328409238509324850943850943825024385\r\n")

        expect(parser.read).to be_a Integer
      end
    end

    describe "aggregate types" do
      it "parses arrays" do
        write_connection.write("*2\r\n+one\r\n+two\r\n")

        expect(parser.read).to be_an Array
      end

      it "parses maps" do
        write_connection.write("%2\r\n+one\r\n+two\r\n")

        expect(parser.read).to be_a Hash
      end

      it "parses sets" do
        write_connection.write("~2\r\n+one\r\n+two\r\n")

        expect(parser.read).to be_a Set
      end

      it "parses attributes" do
        write_connection.write("|2\r\n+one\r\n+two\r\n")

        expect(parser.read).to be_an Attribute
      end
    end
  end
end
