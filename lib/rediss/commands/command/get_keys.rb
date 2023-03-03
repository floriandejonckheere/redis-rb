# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class GetKeys < Command
        command "GETKEYS"

        self.metadata = {
          summary: "Extract keys given a full Redis command",
          since: "2.8.13",
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
