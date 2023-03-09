# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Docs do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { [] }

  describe "#execute" do
    it "returns the info of all supported commands" do
      expect(command.execute).to be_an Array
    end

    context "when a command name is passed" do
      let(:arguments) { ["ping"] }

      it "returns the info of the command" do
        expect(command.execute).to eq(["ping", [
                                        "summary", "Ping the server",
                                        "since", "1.0.0",
                                        "group", "connection",
                                        "complexity", "O(1)",
                                        "arguments", [
                                          ["name", "message", "type", "string", "flags", ["optional"]],
                                        ],
                                      ],])
      end
    end

    context "when an unknown command is passed" do
      let(:arguments) { ["unknown"] }

      it "returns nil" do
        expect(command.execute).to eq [nil]
      end
    end
  end
end
