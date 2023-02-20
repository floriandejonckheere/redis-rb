# frozen_string_literal: true
# typed: true

module Redis
  module Commands
    class Parser
      extend T::Sig

      sig { returns(T::Array[Redis::Type]) }
      attr_reader :arguments

      sig { params(arguments: T.nilable(Redis::Type)).void }
      def initialize(arguments)
        @arguments = Array(arguments)
      end

      sig { returns(Redis::Command) }
      def read
        command = arguments
          .shift
          .to_s

        raise ArgumentError, "no command specified" unless command

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
