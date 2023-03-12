# frozen_string_literal: true
# typed: true

module Rediss
  module Arguments
    class Key < Argument
      child :key

      sig { returns(::Integer) }
      attr_reader :key_spec_index

      sig { params(name: ::Symbol, key_spec_index: ::Integer, flags: T::Array[::Symbol]).void }
      def initialize(name, key_spec_index:, flags: [])
        super(name, flags:)

        @key_spec_index = key_spec_index
      end

      sig { override.params(argument: Rediss::Type).returns(Rediss::Type) }
      def parse(argument)
        argument
      end
    end
  end
end
