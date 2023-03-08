# frozen_string_literal: true

RSpec.describe Rediss::Connection do
  subject(:connection) { described_class.new(io) }

  describe "#authenticate" do
    context "when username and password are not set" do
      it "returns true" do
        expect(connection.authenticate("foo", "bar")).to be true
      end
    end

    context "when username and password are set" do
      subject(:connection) { described_class.new(io, { username: "foo", password: "bar" }) }

      it "returns true when the credentials are correct" do
        expect(connection.authenticate("foo", "bar")).to be true
      end

      it "returns false when the credentials are incorrect" do
        expect(connection.authenticate("foo", "baz")).to be false
      end
    end
  end

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
