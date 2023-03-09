# frozen_string_literal: true

RSpec.describe "HELLO", integration: true do
  it "returns the same responses as Redis" do
    actual, expected = compare_rediss_with_redis { |r| r.hello(["3"]) }

    # Compare only keys, not values
    expect(actual.keys).to eq expected.keys
  end
end
