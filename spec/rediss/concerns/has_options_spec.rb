# frozen_string_literal: true

RSpec.describe Rediss::HasOptions do
  subject(:my_instance) { my_class.new(arguments) }

  let(:my_class) do
    Class.new do
      include Rediss::HasOptions

      option "--[no-]boolean", "Boolean option"
      option "--integer N", Integer, "Integer option"
      option "--string STRING", "String option"

      defaults boolean: false,
               integer: 1,
               string: "foo"

      def initialize(args)
        # Parse command-line arguments
        self.class.parser.parse!(args, into: options)
      end
    end
  end

  let(:arguments) { ["--boolean", "--integer", "3", "--string", "bar"] }

  it "parses options" do
    expect(my_instance.options).to include boolean: true,
                                           integer: 3,
                                           string: "bar"
  end

  context "when no arguments are given" do
    let(:arguments) { [] }

    it "falls back to default values" do
      expect(my_instance.options).to include boolean: false,
                                             integer: 1,
                                             string: "foo"
    end
  end
end
