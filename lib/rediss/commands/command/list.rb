# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class List < Command
        self.metadata = {
          summary: "Get an array of Redis command names",
          since: "7.0.0",
          group: "server",
          complexity: "O(N) where N is the total number of Redis commands",
          arguments: [
            { name: "filterby", type: "oneof", token: "FILTERBY", flags: ["optional"], arguments: [
              { name: "module-name", type: "string", token: "MODULE" },
              { name: "category", type: "string", token: "ACLCAT" },
              { name: "pattern", type: "pattern", token: "PATTERN" },
            ], },
          ],
        }

        def execute
          # TODO: implement FILTERBY/ACLCAT/PATTERN arguments
          return Error.new("ERR", "wrong number of arguments for 'COMMAND LIST' command") if arguments.any?

          Rediss::Command
            .subcommands
            .values
            .map(&:command_name)
        end
      end

      subcommands["LIST"] = List
    end
  end
end
