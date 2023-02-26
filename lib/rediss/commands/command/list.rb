# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class List < Rediss::Command
        def execute
          # TODO: implement FILTERBY/ACLCAT/PATTERN arguments
          return Error.new("ERR", "wrong number of arguments for 'COMMAND LIST' command") if arguments.any?

          Rediss::Command
            .descendants
            .map(&:name)
            .map(&:downcase)
        end
      end
    end
  end
end
