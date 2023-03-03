# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Ping < Rediss::Command
      command "PING"

      self.arity = -1
      self.flags = [:fast]
      self.metadata = {
        summary: "Ping the server",
        since: "1.0.0",
        group: "connection",
        complexity: "O(1)",
        arguments: [
          { name: "message", type: "string", flags: ["optional"] },
        ],
      }

      def execute
        return Error.new("ERR", "wrong number of arguments for 'PING' command") if arguments.count > 1

        arguments.first || "PONG"
      end
    end
  end
end
