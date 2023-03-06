# frozen_string_literal: true

RSpec.describe Rediss::Connection do
  subject(:connection) { described_class.new(io) }

  describe "#database, #select" do
    it "defaults to database 0" do
      expect(connection.database.index).to eq 0
    end

    it "selects the database by index" do
      connection.select(1)

      expect(connection.database.index).to eq 1
    end
  end
end
