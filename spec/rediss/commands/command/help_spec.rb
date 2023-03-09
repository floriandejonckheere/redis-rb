# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Help do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { [] }

  describe "#execute" do
    it "returns the help of supported commands" do
      expect(command.execute).to be_an Array
    end
  end
end
