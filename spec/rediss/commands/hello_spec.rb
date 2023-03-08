# frozen_string_literal: true

RSpec.describe Rediss::Commands::Hello do
  subject(:command) { described_class.new(arguments, default_connection) }

  let(:arguments) { ["3"] }

  describe "#execute" do
    it "returns the same responses as Redis" do
      expected = $redis.with { |r| r.hello(arguments) }

      # Compare only keys, not values
      expect(command.execute.keys).to eq expected.keys
    end

    it "returns the current server and connection properties" do
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

      it "returns the current server and connection properties" do
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

    context "when an invalid protocol version is passed" do
      let(:arguments) { ["2"] }

      it "returns an error" do
        error = command.execute

        expect(error).to be_an Error
        expect(error.code).to eq "NOPROTO"
        expect(error.message).to eq "unsupported protocol version"
      end
    end

    describe "AUTH option" do
      let(:default_options) { { username: "foo", password: "bar" } }

      context "when the password is correct" do
        let(:arguments) { ["3", "AUTH", "foo", "bar"] }

        it "returns the current server and connection properties" do
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

      context "when the password is incorrect" do
        let(:arguments) { ["3", "AUTH", "foo", "baz"] }

        it "returns an error" do
          error = command.execute

          expect(error).to be_an Error
          expect(error.code).to eq "WRONGPASS"
          expect(error.message).to eq "invalid username-password pair"
        end
      end
    end
  end
end
