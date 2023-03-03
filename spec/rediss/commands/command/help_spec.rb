# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Help do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { [] }

  describe "#execute" do
    it "raises an error" do
      expect { command.execute }.to raise_error NotImplementedError
    end
  end
end
