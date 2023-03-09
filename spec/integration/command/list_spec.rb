# frozen_string_literal: true

RSpec.describe "COMMAND LIST", integration: true do
  it "returns the same responses as Redis" do
    actual, expected = compare_rediss_with_redis { |r| r.command("LIST") }

    # Don't compare exact values
    expect(actual).to include expected
  end
end
