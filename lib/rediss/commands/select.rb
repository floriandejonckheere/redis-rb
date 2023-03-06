# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Select < Rediss::Command
      command "SELECT"

      self.arity = 2
      self.flags = [:loading, :stale, :fast]
      self.metadata = {
        summary: "Change the selected database for the current connection",
        since: "1.0.0",
        group: "connection",
        complexity: "O(1)",
        arguments: [
          { name: "index", type: "integer" },
        ],
      }

      def execute
        return Error.new("ERR", "value is not an integer or out of range") unless index
        return Error.new("ERR", "DB index is out of range") unless index.in? 0..15

        "OK"
      end

      private

      def index
        T.cast(arguments.first, Integer)
      rescue TypeError
        nil
      end
    end
  end
end
