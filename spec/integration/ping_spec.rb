# frozen_string_literal: true

RSpec.describe "PING", integration: true do
  it "supports the command" do
    actual, expected = compare_rediss_with_redis { |r| r.ping("hello world") }

    expect(actual).to eq expected
  end
end
