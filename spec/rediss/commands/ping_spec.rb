# frozen_string_literal: true

RSpec.describe Rediss::Commands::Ping do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { ["hello world"] }

  describe "#execute" do
    it "returns the same responses as Redis" do
      expected = $redis.with { |r| r.ping(arguments) }

      expect(command.execute).to eq expected
    end

    it "returns a string" do
      expect(command.execute).to be_a String
      expect(command.execute).to eq "hello world"
    end

    context "when no arguments are passed" do
      let(:arguments) { [] }

      it "returns a string" do
        expect(command.execute).to be_a String
        expect(command.execute).to eq "PONG"
      end
    end

    context "when more than one argument is passed" do
      let(:arguments) { ["hello", "world"] }

      it "returns an error" do
        error = command.execute

        expect(error).to be_an Error
        expect(error.code).to eq "ERR"
        expect(error.message).to eq "wrong number of arguments for 'PING' command"
      end
    end
  end
end
