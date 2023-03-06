# frozen_string_literal: true

RSpec.describe Rediss::Database do
  subject(:database) { described_class.new(index) }

  let(:index) { 0 }

  describe "#index" do
    it "returns the index" do
      expect(database.index).to eq index
    end
  end

  describe ".[]" do
    it "returns the database for the given index" do
      expect(described_class[0].index).to eq database.index
    end
  end
end
