# frozen_string_literal: true

RSpec.describe "HELLO", integration: true do
  it "supports the command" do
    actual, expected = compare_rediss_with_redis { |r| r.hello("3") }

    expect(actual).to eq expected
  end
end
