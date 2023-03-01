# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Info do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { [] }

  describe "#execute" do
    Rediss::Command.subcommands.each_key do |command_name|
      context "when '#{command_name}' is passed" do
        let(:arguments) { [command_name] }

        it "returns the same responses as Redis" do
          expected = $redis.with { |r| r.command([:info, *arguments]) }.first

          # TODO: first key, last key, step, acl categories, tips, key specifications, subcommands
          expect(command.execute.first[..2]).to eq expected[..2]
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
