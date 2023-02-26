# frozen_string_literal: true

RSpec.describe Rediss::TypeParser do
  subject(:parser) { described_class.new(rsocket) }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#read" do
    it "raises for unknown types" do
      wsocket.write("&ERR unknown command 'X'\r\n")

      expect { parser.read }.to raise_error ArgumentError
    end

    describe "aggregate types" do
      it "parses blob strings" do
        wsocket.write("$11\r\nhello world\r\n")

        expect(parser.read).to be_a String
      end

      it "parses simple strings" do
        wsocket.write("+hello world\r\n")

        expect(parser.read).to be_a String
      end

      it "parses simple errors" do
        wsocket.write("-ERR unknown command 'X'\r\n")

        expect(parser.read).to be_an Error
      end

      it "parses numbers" do
        wsocket.write(":1\r\n")

        expect(parser.read).to be_an Integer
      end

      it "parses nulls" do
        wsocket.write("_\r\n")

        expect(parser.read).to be_nil
      end

      it "parses doubles" do
        wsocket.write(",1.23\r\n")

        expect(parser.read).to be_a Float
      end

      it "parses booleans" do
        wsocket.write("#t\r\n")

        expect(parser.read).to be true
      end

      it "parses blob errors" do
        wsocket.write("!21\r\nSYNTAX invalid syntax\r\n")

        expect(parser.read).to be_an Error
      end

      it "parses verbatim strings" do
        wsocket.write("=15\r\ntxt:Some string\r\n")

        expect(parser.read).to be_a String
      end

      it "parses big decimals" do
        wsocket.write("(3492890328409238509324850943850943825024385\r\n")

        expect(parser.read).to be_a Integer
      end
    end

    describe "aggregate types" do
      it "parses arrays" do
        wsocket.write("*2\r\n+one\r\n+two\r\n")

        expect(parser.read).to be_an Array
      end

      it "parses maps" do
        wsocket.write("%2\r\n+one\r\n+two\r\n")

        expect(parser.read).to be_a Hash
      end

      it "parses sets" do
        wsocket.write("~2\r\n+one\r\n+two\r\n")

        expect(parser.read).to be_a Set
      end

      it "parses attributes" do
        wsocket.write("|2\r\n+one\r\n+two\r\n")

        expect(parser.read).to be_an Attribute
      end
    end
  end
end