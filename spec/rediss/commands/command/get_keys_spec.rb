# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::GetKeys do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { [] }

  describe "#execute" do
    it "raises an error" do
      expect { command.execute }.to raise_error NotImplementedError
    end
  end
end
