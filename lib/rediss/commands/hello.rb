# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Hello < Rediss::Command
      self.arity = -1
      self.flags = [:noscript, :loading, :stale, :fast, :no_auth, :allow_busy]

      def execute
        return Error.new("AUTH", "not implemented yet") if arguments.count > 1
        return Error.new("NOPROTO", "unsupported protocol version") unless version == 3

        {
          "server" => "rediss",
          "version" => Rediss::VERSION,
          "proto" => Rediss::PROTOCOL,
          "id" => 1,
          "mode" => "standalone",
          "role" => "master",
          "modules" => [],
        }
      end

      private

      def version
        T.cast(arguments.first || Rediss::PROTOCOL, Integer)
      end
    end

    Registry.register("HELLO", Hello)
  end
end
