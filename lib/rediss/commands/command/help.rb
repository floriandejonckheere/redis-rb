# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Command
      class Help < Command
        command "HELP"

        self.metadata = {
          summary: "Show helpful text about the different subcommands",
          since: "5.0.0",
          group: "server",
          complexity: "O(1)",
        }

        def execute
          raise NotImplementedError
        end
      end
    end
  end
end
