# frozen_string_literal: true
# typed: true

module Redis
  module Commands
    class Parser
      extend T::Sig

      sig { returns(Redis::Type) }
      attr_reader :arguments

      sig { params(arguments: Redis::Type).void }
      def initialize(arguments)
        @arguments = arguments
      end

      sig { returns(Redis::Command) }
      def read
        command, args = case arguments
                        when Types::Array
                          [arguments.value.shift, arguments]
                        else
                          arguments
                        end

        klass = command.value.downcase.camelize

        # Instantiate command class
        "Redis::Commands::#{klass}"
          .constantize
          .new(args)
      rescue NameError
        raise ArgumentError, "unknown command '#{command.value.upcase}'"
      end
    end
  end
end
