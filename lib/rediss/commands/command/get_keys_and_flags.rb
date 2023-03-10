# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class GetKeysAndFlags < Command
        child "GETKEYSANDFLAGS"

        self.metadata = {
          summary: "Extract keys and access flags given a full Redis command",
          since: nil,
          group: "server",
          complexity: "O(N) where N is the number of arguments to the command",
        }

        def execute
          raise NotImplementedError
        end
      end
    end
  end
end
