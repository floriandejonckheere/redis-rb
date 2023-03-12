# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class Help < Command
        child "HELP"

        self.metadata = {
          summary: "Show helpful text about the different subcommands",
          since: "1.0.0",
          group: "server",
          complexity: "O(1)",
        }

        def execute
          [
            "COMMAND <subcommand> [<arg> [value] [opt] ...]. Subcommands are:",
            "(no subcommand)",
            "    Return details about all Redis commands.",
            "COUNT",
            "    Return the total number of commands in this Redis server.",
            "LIST",
            "    Return a list of all commands in this Redis server.",
            "INFO [<command-name> ...]",
            "    Return details about multiple Redis commands.",
            "    If no command names are given, documentation details for all",
            "    commands are returned.",
            "DOCS [<command-name> ...]",
            "    Return documentation details about multiple Redis commands.",
            "    If no command names are given, documentation details for all",
            "    commands are returned.",
            "GETKEYS <full-command>",
            "    Return the keys from a full Redis command.",
            "GETKEYSANDFLAGS <full-command>",
            "    Return the keys and the access flags from a full Redis command.",
            "HELP",
            "    Prints this help.",
          ]
        end
      end
    end
  end
end
