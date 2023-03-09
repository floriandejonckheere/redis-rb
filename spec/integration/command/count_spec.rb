# frozen_string_literal: true

RSpec.describe "COMMAND COUNT", integration: true do
  it "returns the same responses as Redis" do
    actual, expected = compare_rediss_with_redis { |r| r.command("COUNT") }

    # Don't compare exact values
    expect(actual).to be < expected
  end
end
