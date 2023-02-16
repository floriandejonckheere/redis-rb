# frozen_string_literal: true

RSpec.describe Redis::Commands::Ping do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { ["hello world"] }

  describe "#execute" do
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
        expect(command.execute).to be_an Error
        expect(command.execute.code).to eq "ERR"
        expect(command.execute.message).to eq "wrong number of arguments for 'ping' command"
      end
    end
  end
end
