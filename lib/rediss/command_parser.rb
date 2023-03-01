# frozen_string_literal: true
# typed: true

module Rediss
  class CommandParser
    extend T::Sig

    sig { returns(T::Array[Rediss::Type]) }
    attr_reader :arguments

    sig { params(arguments: Rediss::Type).void }
    def initialize(arguments)
      @arguments = Array(arguments)
    end

    sig { returns(Rediss::Command) }
    def read
      command = arguments
        .shift

      raise ArgumentError, "no command specified" unless command

      # Assert first argument is a string
      command = T.cast(command, String)

      # Infer command name
      name = command
        .upcase

      # Fetch command class
      klass = Command
        .subcommands
        .fetch(name, nil)

      raise ArgumentError, "unknown command '#{name}'" unless klass

      # Instantiate command class
      klass
        .new(arguments)
    end
  end
end
