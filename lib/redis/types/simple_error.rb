# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class SimpleError < Type
      attr_reader :message

      sig { params(message: String).void }
      def initialize(message)
        @message = message
      end

      sig { returns(String) }
      def to_s
        "-ERR #{message}\r\n"
      end

      sig { params(socket: IO).returns(T.attached_class) }
      def self.parse(socket)
        new socket
          .readline
          .chomp
          .delete_prefix("ERR ")
      end
    end
  end
end
