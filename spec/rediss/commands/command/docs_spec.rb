# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Docs do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { [] }

  describe "#execute" do
    Rediss::Command.subcommands.each_key do |command_name|
      context "when '#{command_name}' is passed" do
        let(:arguments) { [command_name] }

        it "returns the same responses as Redis" do
          expected = $redis.with { |r| r.command([:docs, *arguments]) }

          expect(command.execute).to eq expected
        end
      end
    end

    it "returns the info of supported commands" do
      expect(command.execute).to be_an Array
    end

    context "when an unknown command is passed" do
      let(:arguments) { ["unknown"] }

      it "returns nil" do
        expect(command.execute).to eq [nil]
      end
    end
  end
end
