# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class Docs < Command
        child "DOCS"

        self.metadata = {
          summary: "Get array of specific Redis command documentation",
          since: "1.0.0",
          group: "server",
          complexity: "O(N) where N is the number of commands to look up",
          arguments: [
            { name: "command-name", type: "string", flags: ["optional", "multiple"] },
          ],
        }

        def execute
          # Display info on all commands by default
          @arguments = Rediss::Command.children.keys if arguments.empty?

          arguments.flat_map do |command|
            # Assert command is a string
            command = T.cast(command, String)

            # Infer command name
            name = command
              .upcase

            # Fetch command class
            klass = Rediss::Command
              .children
              .fetch(name, nil)

            # Return nil if command does not exist
            next unless klass

            # Embed subcommands in metadata
            metadata = klass
              .metadata
              .merge(subcommands: klass.children.each_value.flat_map { |k| ["#{klass.child_name.downcase}|#{k.child_name.downcase}", k.metadata] }.presence)
              .compact
              .deep_stringify_keys
              .deep_flatten

            # Return command documentation
            [
              name.downcase,
              metadata,
            ]
          end
        end
      end
    end
  end
end
