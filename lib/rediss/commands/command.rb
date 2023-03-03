# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command < Rediss::Command
      command "COMMAND"

      self.arity = -1
      self.flags = [:loading, :stale]
      self.metadata = {
        summary: "Get array of Redis command details",
        since: "2.8.13",
        group: "server",
        complexity: "O(N) where N is the total number of Redis commands",
      }

      def execute
        return Info.new([]).execute if arguments.empty?

        subcommand = arguments
          .shift

        # Assert subcommand is a string
        subcommand = T.cast(subcommand, String)

        # Infer subcommand name
        name = subcommand
          .upcase

        # Infer subcommand class
        klass = self
          .class
          .subcommands
          .fetch(name, nil)

        return Error.new("ERR", "unknown subcommand '#{name}'") unless klass

        # Instantiate, validate, and execute subcommand class
        klass
          .new(arguments)
          .tap(&:validate)
          .execute
      end
    end
  end
end
