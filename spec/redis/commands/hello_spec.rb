# frozen_string_literal: true

RSpec.describe Redis::Commands::Hello do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { build(:array, value: [build(:blob_string, value: "3")]) }

  describe "#execute" do
    it "returns a string" do
      expect(command.execute).to be_a(Redis::Types::SimpleString)
    end

    context "when no arguments are passed" do
      let(:arguments) { build(:array, value: []) }

      it "returns an error" do
        expect(command.execute).to be_a(Redis::Types::SimpleError)
      end
    end

    context "when more than one argument is passed" do
      let(:arguments) { build(:array, value: [build(:blob_string, value: "3"), build(:blob_string, value: "AUTH")]) }

      it "returns an error" do
        expect(command.execute).to be_a(Redis::Types::SimpleError)
      end
    end

    context "when an invalid protocol version is passed" do
      let(:arguments) { build(:array, value: [build(:blob_string, value: "2")]) }

      it "returns an error" do
        expect(command.execute).to be_a(Redis::Types::SimpleError)
      end
    end
  end
end
