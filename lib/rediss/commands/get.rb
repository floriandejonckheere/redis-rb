# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Get < Rediss::Command
      child "GET"

      self.arity = 2
      self.flags = [:readonly, :fast]
      self.metadata = {
        summary: "Get the value of a key",
        since: "1.0.0",
        group: "string",
        complexity: "O(1)",
        arguments: [
          { name: "key", type: "key", key_spec_index: 0 },
        ],
      }

      def execute
        key = arguments.shift.to_s

        # Look up entry
        entry = connection
          .database
          .get(key)

        return if entry.value.nil?

        return Error.new("WRONGTYPE", "Operation against a key holding the wrong kind of value") unless entry.string?

        entry.value
      end
    end
  end
end
