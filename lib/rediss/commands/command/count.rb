# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class Count < Command
        def execute
          return Error.new("ERR", "wrong number of arguments for 'COMMAND COUNT' command") if arguments.any?

          Rediss::Command
            .subclasses
            .count
        end
      end
    end
  end
end
