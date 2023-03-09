# frozen_string_literal: true
# typed: true

module Rediss
  module Commands
    class Hello < Rediss::Command
      command "HELLO"

      self.arity = -1
      self.flags = [:noscript, :loading, :stale, :fast, :no_auth, :allow_busy]
      self.metadata = {
        summary: "Handshake with Redis",
        since: "6.0.0",
        group: "connection",
        complexity: "O(1)",
        history: [
          ["6.2.0", "`protover` made optional; when called without arguments the command reports the current connection's context."],
        ],
        arguments: [
          { name: "arguments", type: "block", flags: ["optional"], arguments: [
            { name: "protover", type: "integer" },
            { name: "username_password", type: "block", token: "AUTH", flags: ["optional"], arguments: [
              { name: "username", type: "string" },
              { name: "password", type: "string" },
            ], },
            { name: "clientname", type: "string", token: "SETNAME", flags: ["optional"] },
          ], },
        ],
      }

      def execute
        return Error.new("NOPROTO", "unsupported protocol version") unless version == 3

        if arguments.any?
          token = arguments.shift&.to_s&.upcase

          case token
          when "AUTH"
            username = arguments.shift
            password = arguments.shift
          when "SETNAME"
            connection.name = arguments.shift&.to_s

            return "OK"
          else
            return Error.new("ERR", "invalid token")
          end

          return Error.new("WRONGPASS", "invalid username-password pair") unless connection.authenticate(username, password)
        end

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
        @version ||= arguments.shift&.to_s&.to_i || Rediss::PROTOCOL
      end
    end
  end
end
