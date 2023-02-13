# frozen_string_literal: true

RSpec.describe Redis::Commands::Hello do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { build(:array, value: [build(:blob_string, value: "3")]) }

  describe "#execute" do
    it "returns a map" do
      expect(command.execute).to be_a(Redis::Types::Map)
      expect(command.execute.value.transform_keys(&:value).transform_values(&:value)).to include(
        "server" => "redis-rb",
        "version" => Redis::VERSION,
        "proto" => Redis::PROTOCOL,
        "id" => 1,
        "mode" => "standalone",
        "role" => "master",
        "modules" => [],
      )
    end

    context "when no arguments are passed" do
      let(:arguments) { build(:array, value: []) }

      it "returns a map" do
        expect(command.execute).to be_a(Redis::Types::Map)
        expect(command.execute.value.transform_keys(&:value).transform_values(&:value)).to include(
          "server" => "redis-rb",
          "version" => Redis::VERSION,
          "proto" => Redis::PROTOCOL,
          "id" => 1,
          "mode" => "standalone",
          "role" => "master",
          "modules" => [],
        )
      end
    end

    context "when more than one argument is passed" do
      let(:arguments) { build(:array, value: [build(:blob_string, value: "3"), build(:blob_string, value: "AUTH")]) }

      it "returns an error" do
        expect(command.execute).to be_a(Redis::Types::SimpleError)
        expect(command.execute.value).to eq "AUTH not implemented yet"
      end
    end

    context "when an invalid protocol version is passed" do
      let(:arguments) { build(:array, value: [build(:blob_string, value: "2")]) }

      it "returns an error" do
        expect(command.execute).to be_a(Redis::Types::SimpleError)
        expect(command.execute.value).to eq "NOPROTO unsupported protocol version"
      end
    end
  end
end
