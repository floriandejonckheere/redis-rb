# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class List < Command
        def execute
          # TODO: implement FILTERBY/ACLCAT/PATTERN arguments
          return Error.new("ERR", "wrong number of arguments for 'COMMAND LIST' command") if arguments.any?

          commands
            .map(&:command_name)
        end
      end
    end
  end
end
