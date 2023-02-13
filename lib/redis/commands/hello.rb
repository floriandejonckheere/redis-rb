# frozen_string_literal: true
# typed: true

module Redis
  module Commands
    class Hello < Command
      def execute
        return Types::SimpleError.new("AUTH not implemented yet") unless arguments&.value&.count == 1

        version = arguments&.value&.shift&.value

        return Types::SimpleError.new("NOPROTO sorry this protocol version is not supported") unless version == "3"

        # TODO: return map
        Types::SimpleString.new("OK")
      end
    end
  end
end
