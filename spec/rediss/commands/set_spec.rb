# frozen_string_literal: true

RSpec.describe Rediss::Commands::Set do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { ["my_key", "my_value"] }

  describe "#execute" do
    it "returns OK" do
      expect(command.execute).to eq "OK"
    end

    it "sets the value of the key" do
      command.execute

      expect(default_database.get("my_key").value).to eq "my_value"
    end
  end
end
