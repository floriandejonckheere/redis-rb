# frozen_string_literal: true

RSpec.describe Rediss::Commands::Command::Info do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { [] }

  describe "#execute" do
    it "returns the info of supported commands" do
      expect(command.execute).to be_an Array
    end

    context "when a command name is passed" do
      let(:arguments) { ["ping"] }

      it "returns the info of the command" do
        expect(command.execute).to eq([
                                        [
                                          "ping",
                                          -1,
                                          ["fast"],
                                          0,
                                          0,
                                          0,
                                          [],
                                          [],
                                          [],
                                          [],
                                        ],
                                      ])
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
