# frozen_string_literal: true

RSpec.describe Hash do
  subject(:type) { value }

  let(:value) { { "hello" => "world" } }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(rsocket) }

  describe "#deep_flatten" do
    let(:value) { { "hello" => { "world" => "!" }, "goodbye" => ["cruel", { "world" => "!" }] } }

    it "deep flattens the hash" do
      expect(type.deep_flatten).to eq ["hello", ["world", "!"], "goodbye", ["cruel", ["world", "!"]]]
    end
  end

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "%2\r\n$5\r\nhello\r\n$5\r\nworld\r\n"
    end
  end

  describe "#to_pretty_s" do
    let(:value) { { "hello" => { "world" => "!" }, "goodbye" => ["cruel", { "world" => "!" }] } }

    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "1) \"hello\"\n2) 1) \"world\"\n   2) \"!\"\n3) \"goodbye\"\n4) 1) \"cruel\"\n   2) 1) \"world\"\n      2) \"!\""
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      wsocket.write("2\r\n$5\r\nhello\r\n$5\r\nworld\r\n")

      type = described_class.from_resp3("%", rsocket) { parser.read }

      expect(type).to eq({ "hello" => "world" })
    end
  end
end
