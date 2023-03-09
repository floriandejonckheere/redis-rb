# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class Info < Command
        command "INFO"

        self.metadata = {
          summary: "Get array of specific Redis command details, or all when no argument is given.",
          since: "1.0.0",
          group: "server",
          complexity: "O(N) where N is the number of commands to look up",
          arguments: [
            { name: "command-name", type: "string", flags: ["optional", "multiple"] },
          ],
        }

        def execute
          # Display info on all commands by default
          @arguments = Rediss::Command.subcommands.keys if arguments.empty?

          arguments.map do |command|
            # Assert command is a string
            command = T.cast(command, String)

            # Infer command name
            name = command
              .upcase

            # Fetch command class
            klass = Rediss::Command
              .subcommands
              .fetch(name, nil)

            # Return nil if command does not exist
            next unless klass

            # Return command info
            [
              klass.command_name.downcase, # name
              klass.arity, # arity
              klass.flags.map(&:to_s), # flags
              0, # TODO: first key
              0, # TODO: last key
              0, # TODO: step
              [], # TODO: acl categories
              [], # TODO: tips
              [], # TODO: key specifications
              [], # TODO: subcommands
            ]
          end
        end
      end
    end
  end
end
