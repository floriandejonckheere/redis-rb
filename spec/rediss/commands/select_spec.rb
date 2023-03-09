# frozen_string_literal: true

RSpec.describe Rediss::Commands::Select do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { [3] }

  describe "#execute" do
    it "returns OK" do
      expect(command.execute).to eq "OK"
    end

    it "sets the selected database for the current connection" do
      expect { command.execute }.to change { default_connection.database.index }.from(0).to 3
    end

    context "when a non-integer value is passed" do
      let(:arguments) { ["foo"] }

      it "returns an error" do
        error = command.execute

        expect(error).to be_an Error
        expect(error.code).to eq "ERR"
        expect(error.message).to eq "value is not an integer or out of range"
      end
    end

    context "when a value out of range is passed" do
      let(:arguments) { [99] }

      it "returns an error" do
        error = command.execute

        expect(error).to be_an Error
        expect(error.code).to eq "ERR"
        expect(error.message).to eq "DB index is out of range"
      end
    end
  end
end
