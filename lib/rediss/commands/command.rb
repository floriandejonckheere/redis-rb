# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command < Rediss::Command
      self.arity = -1
      self.flags = [:loading, :stale]

      def execute
        # TODO: return all details when no subcommand is specified
        return Error.new("ERR", "no subcommand specified") if arguments.empty?

        subcommand = arguments
          .shift

        # Assert subcommand is a string
        subcommand = T.cast(subcommand, String)

        # Infer subcommand name
        name = subcommand
          .downcase
          .camelize

        # Infer subcommand class
        klass = "Rediss::Commands::Command::#{name}"
          .safe_constantize

        return Error.new("ERR", "unknown subcommand '#{subcommand.upcase}'") unless klass

        # Instantiate, validate, and execute subcommand class
        klass
          .new(arguments)
          .tap(&:validate)
          .execute
      end

      protected

      def commands
        Rediss::Command
          .subclasses
      end
    end
  end
end
