# frozen_string_literal: true

RSpec.describe Rediss::HasChildren do
  subject(:my_instance) { described_class }

  let!(:parent_class) do
    Class.new do
      include Rediss::HasChildren
    end
  end

  let!(:child_class) do
    Class.new(parent_class) do
      child :child
    end
  end

  let!(:grandchild_class) do
    Class.new(child_class) do
      child :grandchild
    end
  end

  describe "#children" do
    it "has children" do
      expect(parent_class.children).to eq child: child_class
    end

    it "has grandchildren" do
      expect(child_class.children).to eq grandchild: grandchild_class
    end
  end
end
