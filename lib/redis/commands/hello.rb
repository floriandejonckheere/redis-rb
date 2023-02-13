# frozen_string_literal: true
# typed: true

module Redis
  module Commands
    class Hello < Command
      def execute
        return Types::SimpleError.new("AUTH not implemented yet") if arguments&.value&.count&.> 1
        return Types::SimpleError.new("NOPROTO unsupported protocol version") unless version == 3

        # TODO: return map
        Types::SimpleString.new("OK")
      end

      private

      def version
        arguments&.value&.first&.value&.to_i || Redis::PROTOCOL
      end
    end
  end
end
