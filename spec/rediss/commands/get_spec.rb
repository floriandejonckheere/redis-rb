# frozen_string_literal: true

RSpec.describe Rediss::Commands::Get do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { ["my_key"] }

  describe "#execute" do
    it "returns the value of the key" do
      default_database.get("my_key").value = "my_value"

      expect(command.execute).to eq "my_value"
    end

    context "when the key does not exist" do
      it "returns nil" do
        expect(command.execute).to be_nil
      end
    end

    context "when the key is not a string" do
      it "returns an error" do
        default_database.get("my_key").value = []

        error = command.execute

        expect(error).to be_an Error
        expect(error.code).to eq "WRONGTYPE"
        expect(error.message).to eq "Operation against a key holding the wrong kind of value"
      end
    end
  end
end
