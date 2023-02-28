# frozen_string_literal: true
# typed: true

module Rediss
  class Command
    extend T::Sig
    extend T::Helpers

    abstract!

    # Number of arguments accepted
    class_attribute :arity, default: 1

    # Flags set on the command
    class_attribute :flags, default: []

    # Command metadata
    class_attribute :metadata, default: {}

    sig { returns(T::Array[Rediss::Type]) }
    attr_reader :arguments

    sig { params(arguments: Rediss::Type).void }
    def initialize(arguments)
      @arguments = Array(arguments)
    end

    sig { abstract.returns(Rediss::Type) }
    def execute; end

    sig { returns(T.nilable(Error)) }
    def validate
      # Zero or more arguments
      return if arity == -1

      # Arity always includes the command itself
      n = arity.abs - 1

      if arity.negative?
        # Negative arity means at least N arguments
        return if arguments.count >= n
      elsif arity.positive?
        # Positive arity means exactly N arguments
        return if arguments.count == n
      end

      raise ArgumentError, "wrong number of arguments for '#{self.class.command_name}' command"
    end

    sig { returns(String) }
    def self.command_name
      T.cast(name, String).demodulize.underscore
    end
  end
end
