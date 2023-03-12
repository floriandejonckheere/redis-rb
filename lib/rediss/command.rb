# frozen_string_literal: true
# typed: true

module Rediss
  class Command
    extend T::Sig
    extend T::Helpers
    include HasChildren

    abstract!

    # Number of arguments accepted
    class_attribute :arity, default: 1

    # Flags set on the command
    class_attribute :flags, default: []

    # Command metadata
    class_attribute :metadata, default: {}

    sig { returns(T::Array[Rediss::Type]) }
    attr_reader :arguments

    sig { returns(Connection) }
    attr_reader :connection

    sig { params(arguments: Rediss::Type, connection: Connection).void }
    def initialize(arguments, connection)
      @arguments = Array(arguments)
      @connection = connection
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

      raise ArgumentError, "wrong number of arguments for '#{self.class.child_name}' command"
    end
  end
end
