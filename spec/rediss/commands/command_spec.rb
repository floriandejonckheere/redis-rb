# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { ["count"] }

  describe "#execute" do
    it "instantiates a subcommand" do
      allow(Rediss::Commands::Command::Count)
        .to receive(:new)
        .and_call_original

      command.execute

      expect(Rediss::Commands::Command::Count)
        .to have_received(:new)
        .with([], default_connection)
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
          .with([], default_connection)
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
