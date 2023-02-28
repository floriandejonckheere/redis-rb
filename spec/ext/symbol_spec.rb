# frozen_string_literal: true

RSpec.describe Symbol do
  subject(:type) { value }

  let(:value) { :hello_world }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(rsocket) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "$11\r\nhello_world\r\n"
    end
  end

  describe ".from_resp3" do
    it "raises an error" do
      expect { described_class.from_resp3("$", rsocket) { parser.read } }.to raise_error(ArgumentError, "cannot deserialize symbols")
    end
  end
end
