# frozen_string_literal: true
# typed: true

module Redis
  module Commands
    class Hello < Command
      def execute
        return Types::SimpleError.new("AUTH not implemented yet") if arguments&.value&.count&.> 1
        return Types::SimpleError.new("NOPROTO unsupported protocol version") unless version == 3

        Types::Map.new(
          {
            Types::SimpleString.new("server") => Types::SimpleString.new("redis-rb"),
            Types::SimpleString.new("version") => Types::SimpleString.new(Redis::VERSION),
            Types::SimpleString.new("proto") => Types::Number.new(Redis::PROTOCOL),
            Types::SimpleString.new("id") => Types::Number.new(1),
            Types::SimpleString.new("mode") => Types::SimpleString.new("standalone"),
            Types::SimpleString.new("role") => Types::SimpleString.new("master"),
            Types::SimpleString.new("modules") => Types::Array.new([]),
          },
        )
      end

      private

      def version
        arguments&.value&.first&.value&.to_i || Redis::PROTOCOL
      end
    end
  end
end
