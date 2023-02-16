# frozen_string_literal: true
# typed: true

module Redis
  module Commands
    class Parser
      extend T::Sig

      sig { returns(T::Array[Redis::Type]) }
      attr_reader :arguments

      sig { params(arguments: T::Array[Redis::Type]).void }
      def initialize(arguments)
        @arguments = Array(arguments)
      end

      sig { returns(Redis::Command) }
      def read
        command = arguments
          .shift

        raise ArgumentError, "no command specified" unless command

        # Infer command class
        # FIXME: allow only known commands
        klass = command
          .downcase
          .camelize

        # Instantiate command class
        "Redis::Commands::#{klass}"
          .constantize
          .new(arguments)
      rescue NameError
        raise ArgumentError, "unknown command '#{command.upcase}'"
      end
    end
  end
end
