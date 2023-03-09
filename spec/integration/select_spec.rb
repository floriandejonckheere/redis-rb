# frozen_string_literal: true

RSpec.describe "SELECT", integration: true do
  it "returns the same responses as Redis" do
    actual, expected = compare_rediss_with_redis { |r| r.select("3") }

    expect(actual).to eq expected
  end
end
