# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Ping < Command
      def execute
        return Error.new("ERR", "wrong number of arguments for 'ping' command") if arguments.count > 1

        arguments.first || "PONG"
      end
    end
  end
end
