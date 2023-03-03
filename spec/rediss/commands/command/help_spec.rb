# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Help do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { [] }

  describe "#execute" do
    it "returns the same responses as Redis" do
      expected = $redis.with { |r| r.command(:help) }

      expect(command.execute).to eq expected
    end

    it "returns the help of supported commands" do
      expect(command.execute).to be_an Array
    end
  end
end
