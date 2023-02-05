# frozen_string_literal: true

module Redis
  module Types
    class SimpleError
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def to_s
        "-ERR #{message}\r\n"
      end

      def self.parse(socket)
        new socket
          .readline("\r\n")
          .chomp
          .delete_prefix("ERR ")
      end
    end
  end
end
