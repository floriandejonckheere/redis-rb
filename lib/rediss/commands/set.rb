# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Set < Rediss::Command
      command "SET"

      self.arity = 2
      self.flags = [:write, :denyoom]
      self.metadata = {
        summary: "Set the string value of a key",
        since: "1.0.0",
        group: "string",
        complexity: "O(1)",
        arguments: [
          { name: "key", type: "key", key_spec_index: 0 },
          { name: "value", type: "string" },
          { name: "condition", type: "oneof", since: "2.6.12", flags: [:optional], arguments: [
            { name: "nx", type: "pure-token", token: "NX" },
            { name: "xx", type: "pure-token", token: "XX" },
          ], },
          { name: "get", type: "pure-token", token: "GET", since: "6.2.0", flags: [:optional] },
          { name: "expiration", type: "oneof", flags: [:optional], arguments: [
            { name: "seconds", type: "integer", token: "EX", since: "2.6.12" },
            { name: "milliseconds", type: "integer", token: "PX", since: "2.6.12" },
            { name: "unix-time-seconds", type: "unix-time", token: "EXAT", since: "6.2.0" },
            { name: "unix-time-milliseconds", type: "unix-time", token: "PXAT", since: "6.2.0" },
            { name: "keepttl", type: "pure-token", token: "KEEPTTL", since: "6.0.0" },
          ], },
        ],
      }

      def execute
        key = arguments.shift.to_s
        value = arguments.shift.to_s

        # Look up entry
        entry = connection
          .database
          .get(key)

        # Set value
        entry
          .value = value

        "OK"
      end
    end
  end
end
