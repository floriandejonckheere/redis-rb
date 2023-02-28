# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command < Rediss::Command
      self.arity = -1
      self.flags = [:loading, :stale]
      self.metadata = {
        summary: "Get array of Redis command details",
        since: "2.8.13",
        group: "server",
        complexity: "O(N) where N is the total number of Redis commands",
        subcommands: [], # TODO: metadata on subcommands
      }

      def execute
        return Info.new([]).execute if arguments.empty?

        subcommand = arguments
          .shift

        # Assert subcommand is a string
        subcommand = T.cast(subcommand, String)

        # Infer subcommand name
        name = subcommand
          .downcase
          .camelize

        # Infer subcommand class
        # TODO: use Registry to fetch subcommand class
        klass = "Rediss::Commands::Command::#{name}"
          .safe_constantize

        return Error.new("ERR", "unknown subcommand '#{subcommand.upcase}'") unless klass

        # Instantiate, validate, and execute subcommand class
        klass
          .new(arguments)
          .tap(&:validate)
          .execute
      end
    end

    Registry.register("COMMAND", Command)
  end
end
