# frozen_string_literal: true

RSpec.describe "COMMAND HELP", integration: true do
  it "returns the same responses as Redis" do
    actual, expected = compare_rediss_with_redis { |r| r.command("HELP") }

    expect(actual).to eq expected
  end
end
