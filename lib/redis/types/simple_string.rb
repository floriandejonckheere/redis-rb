# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class SimpleString < Type
      attr_reader :message

      sig { params(message: String).void }
      def initialize(message)
        @message = message
      end

      sig { returns(String) }
      def to_s
        "+#{message}\r\n"
      end

      sig { params(socket: IO).returns(Redis::Types::SimpleString) }
      def self.parse(socket)
        new socket
          .readline
          .chomp
      end
    end
  end
end
