# frozen_string_literal: true

RSpec.describe "COMMAND DOCS", integration: true do
  Rediss::Command.children.each_key do |command_name|
    context "when '#{command_name}' is passed" do
      let(:arguments) { [command_name] }

      it "returns the same responses as Redis" do
        actual, expected = compare_rediss_with_redis { |r| r.command("DOCS", *arguments) }

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
end
