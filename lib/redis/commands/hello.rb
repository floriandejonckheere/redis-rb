# frozen_string_literal: true
# typed: true

module Redis
  module Commands
    class Hello < Command
      def execute
        return Error.new("AUTH", "not implemented yet") if arguments.count > 1
        return Error.new("NOPROTO", "unsupported protocol version") unless version == 3

        {
          "server" => "redis-rb",
          "version" => Redis::VERSION,
          "proto" => Redis::PROTOCOL,
          "id" => 1,
          "mode" => "standalone",
          "role" => "master",
          "modules" => [],
        }
      end

      private

      def version
        arguments.first&.to_i || Redis::PROTOCOL
      end
    end
  end
end
