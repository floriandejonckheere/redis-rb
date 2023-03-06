# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Docs do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { [] }

  describe "#execute" do
    Rediss::Command.subcommands.each_key do |command_name|
      context "when '#{command_name}' is passed" do
        let(:arguments) { [command_name] }

        it "returns the same responses as Redis" do
          expected = $redis.with { |r| r.command([:docs, *arguments]) }

          actual = command.execute

          # Compare command name
          expect(actual[0]).to eq expected[0]

          # Compare command metadata (per slice: key, value)
          expected_metadata = expected[1].take_while { |s| s != "subcommands" }
          actual_metadata = actual[1].take_while { |s| s != "subcommands" }

          expect(actual_metadata).to eq expected_metadata

          # Compare subcommand metadata (per slice: subcommand, metadata)
          expected_subcommand = expected[1].drop_while { |s| s != "subcommands" }[1]&.each_slice(2)&.to_a
          actual_subcommand = actual[1].drop_while { |s| s != "subcommands" }[1]&.each_slice(2)&.to_a

          expect(actual_subcommand).to match_array expected_subcommand if expected_subcommand && actual_subcommand
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
