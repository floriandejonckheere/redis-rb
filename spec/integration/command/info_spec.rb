# frozen_string_literal: true

RSpec.describe "COMMAND INFO", integration: true do
  Rediss::Command.subcommands.each_key do |command_name|
    context "when '#{command_name}' is passed" do
      let(:arguments) { [command_name] }

      it "returns the same responses as Redis" do
        actual, expected = compare_rediss_with_redis { |r| r.command("INFO", *arguments) }

        # Compare only implemented fields
        expect(actual.first[..2]).to eq expected[..2]
      end
    end
  end
end
