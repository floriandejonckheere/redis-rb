# frozen_string_literal: true

RSpec.describe Rediss::Entry do
  subject(:entry) { described_class.new(value) }

  let(:value) { "hello world" }

  context "when the value is empty" do
    let(:value) { nil }

    it { is_expected.not_to be_string }
  end

  context "when the value is a string" do
    it { is_expected.to be_string }
  end
end
