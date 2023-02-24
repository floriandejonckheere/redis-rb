# frozen_string_literal: true

RSpec.describe Rediss::Commands::Hello do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { [3] }

  describe "#execute" do
    it "returns a map" do
      expect(command.execute).to be_a Hash
      expect(command.execute).to eq(
        "server" => "rediss",
        "version" => Rediss::VERSION,
        "proto" => Rediss::PROTOCOL,
        "id" => 1,
        "mode" => "standalone",
        "role" => "master",
        "modules" => [],
      )
    end

    context "when no arguments are passed" do
      let(:arguments) { [] }

      it "returns a map" do
        expect(command.execute).to be_a Hash
        expect(command.execute).to eq(
          "server" => "rediss",
          "version" => Rediss::VERSION,
          "proto" => Rediss::PROTOCOL,
          "id" => 1,
          "mode" => "standalone",
          "role" => "master",
          "modules" => [],
        )
      end
    end

    context "when more than one argument is passed" do
      let(:arguments) { [3, "AUTH"] }

      it "returns an error" do
        expect(command.execute).to be_an Error
        expect(command.execute.code).to eq "AUTH"
        expect(command.execute.message).to eq "not implemented yet"
      end
    end

    context "when an invalid protocol version is passed" do
      let(:arguments) { [2] }

      it "returns an error" do
        expect(command.execute).to be_an Error
        expect(command.execute.code).to eq "NOPROTO"
        expect(command.execute.message).to eq "unsupported protocol version"
      end
    end
  end
end
