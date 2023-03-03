# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class GetKeysAndFlags < Command
        self.metadata = {
          summary: "Extract keys and access flags given a full Redis command",
          since: "7.0.0",
          group: "server",
          complexity: "O(N) where N is the number of arguments to the command",
        }

        def execute
          raise NotImplementedError
        end

        sig { returns(String) }
        def self.command_name
          "getkeysandflags"
        end
      end

      subcommands["GETKEYSANDFLAGS"] = GetKeysAndFlags
    end
  end
end
