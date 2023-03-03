# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class Count < Command
        command "COUNT"

        self.metadata = {
          summary: "Get total number of Redis commands",
          since: "2.8.13",
          group: "server",
          complexity: "O(1)",
        }

        def execute
          return Error.new("ERR", "wrong number of arguments for 'COMMAND COUNT' command") if arguments.any?

          Rediss::Command
            .subcommands
            .count
        end
      end
    end
  end
end
