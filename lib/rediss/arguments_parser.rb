# frozen_string_literal: true
# typed: true

module Rediss
  class ArgumentsParser
    extend T::Sig

    sig { returns(T::Array[T::Hash[Symbol, T.untyped]]) }
    attr_reader :definitions

    sig { params(definitions: T::Array[String]).void }
    def initialize(definitions)
      @definitions = definitions
    end

    sig { params(args: T::Array[Rediss::Type]).returns(T::Hash[Symbol, Rediss::Type]) }
    def parse(args)
      raise ArgumentError, "expected no args but found one" if args.any? && definitions.empty?

      parsed_arguments = definitions.each_with_object({}) do |definition, arguments|
        raise ArgumentError, "expected a required argument but found none" if definition.required? && args.empty?

        argument = args.shift

        value = definition.parse(argument)

        next unless value

        arguments[definition.name] = value
      end

      raise ArgumentError, "expected no args anymore but found one" if args.any?

      parsed_arguments
    end
  end
end
