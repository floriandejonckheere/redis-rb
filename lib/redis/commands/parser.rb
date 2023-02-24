# frozen_string_literal: true
# typed: true

module Redis
  module Commands
    class Parser
      extend T::Sig

      sig { returns(T::Array[Redis::Type]) }
      attr_reader :arguments

      sig { params(arguments: Redis::Type).void }
      def initialize(arguments)
        @arguments = Array(arguments)
      end

      sig { returns(Redis::Command) }
      def read
        command = arguments
          .shift

        raise ArgumentError, "no command specified" unless command

        # Assert first argument is a string
        command = T.cast(command, String)

        # Infer command name
        name = command
          .downcase
          .camelize

        # Infer command class
        klass = "Redis::Commands::#{name}"
          .safe_constantize

        raise ArgumentError, "unknown command '#{command.upcase}'" unless klass

        # Instantiate command class
        klass
          .new(arguments)
      end
    end
  end
end
