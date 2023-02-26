# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Ping < Rediss::Command
      self.arity = -1
      self.flags = [:fast]

      def execute
        return Error.new("ERR", "wrong number of arguments for 'PING' command") if arguments.count > 1

        arguments.first || "PONG"
      end
    end
  end
end
