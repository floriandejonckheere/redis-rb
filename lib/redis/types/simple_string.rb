# frozen_string_literal: true

module Redis
  module Types
    class SimpleString
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def to_s
        "+#{message}\r\n"
      end

      def self.parse(socket)
        new socket
          .readline
          .chomp
      end
    end
  end
end
