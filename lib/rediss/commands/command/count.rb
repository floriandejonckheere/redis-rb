# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class Count < Command
        child "COUNT"

        self.metadata = {
          summary: "Get total number of Redis commands",
          since: "1.0.0",
          group: "server",
          complexity: "O(1)",
        }

        def execute
          return Error.new("ERR", "wrong number of arguments for 'COMMAND COUNT' command") if arguments.any?

          Rediss::Command
            .children
            .count
        end
      end
    end
  end
end
