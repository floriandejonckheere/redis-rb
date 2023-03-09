# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::List do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { [] }

  describe "#execute" do
    it "returns the list of supported commands" do
      expect(command.execute).to include "ping", "hello"
    end

    context "when an argument is passed" do
      let(:arguments) { ["unknown"] }

      it "returns an error" do
        error = command.execute

        expect(error).to be_an Error
        expect(error.code).to eq "ERR"
        expect(error.message).to eq "wrong number of arguments for 'COMMAND LIST' command"
      end
    end
  end
end
