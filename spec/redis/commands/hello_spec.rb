# frozen_string_literal: true

RSpec.describe Redis::Commands::Hello do
  subject(:command) { described_class.new(arguments) }

  let(:arguments) { build(:array, value: [build(:blob_string, value: "3")]) }
end
