# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class GetKeys < Command
        child "GETKEYS"

        self.metadata = {
          summary: "Extract keys given a full Redis command",
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
