# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { ["count"] }

  describe "#execute" do
    it "returns the same responses as Redis" do
      expected = $redis.with { |r| r.command(arguments) }

      # FIXME: change less than to equal when all commands are implemented
      expect(command.execute).to be < expected
    end

    it "instantiates a subcommand" do
      allow(Rediss::Commands::Command::Count)
        .to receive(:new)
        .and_call_original

      command.execute

      expect(Rediss::Commands::Command::Count)
        .to have_received(:new)
        .with([])
    end

    context "when no arguments are passed" do
      let(:arguments) { [] }

      it "instantiates an info command" do
        allow(Rediss::Commands::Command::Info)
          .to receive(:new)
          .and_call_original

        command.execute

        expect(Rediss::Commands::Command::Info)
          .to have_received(:new)
          .with([])
      end
    end

    context "when an unknown subcommand is passed" do
      let(:arguments) { ["unknown"] }

      it "returns an error" do
        error = command.execute

        expect(error).to be_an Error
        expect(error.code).to eq "ERR"
        expect(error.message).to eq "unknown subcommand 'UNKNOWN'"
      end
    end
  end
end
