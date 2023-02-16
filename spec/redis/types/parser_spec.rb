# frozen_string_literal: true

RSpec.describe Redis::Types::Parser do
  subject(:parser) { described_class.new(rsocket) }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Redis::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  describe "#read" do
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

    it "parses arrays" do
      wsocket.write("*2\r\n+one\r\n+two\r\n")

      expect(parser.read).to be_an Array
    end

    it "parses maps" do
      wsocket.write("%2\r\n+one\r\n+two\r\n")

      expect(parser.read).to be_a Hash
    end

    it "raises for unknown types" do
      wsocket.write("&ERR unknown command 'X'\r\n")

      expect { parser.read }.to raise_error ArgumentError
    end
  end
end
