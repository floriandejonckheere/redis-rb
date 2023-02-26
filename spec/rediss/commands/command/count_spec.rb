# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Count do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { [] }

  describe "#execute" do
    it "returns the number of supported commands" do
      expect(command.execute).to be_an Integer
    end

    context "when an argument is passed" do
      let(:arguments) { ["unknown"] }

      it "returns an error" do
        error = command.execute

        expect(error).to be_an Error
        expect(error.code).to eq "ERR"
        expect(error.message).to eq "wrong number of arguments for 'COMMAND COUNT' command"
      end
    end
  end
end
