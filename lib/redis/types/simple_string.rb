# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class SimpleString < Type
      sig { returns(String) }
      attr_reader :value

      sig { params(value: String).void }
      def initialize(value)
        @value = value
      end

      sig { override.returns(String) }
      def to_s
        "+#{value}\r\n"
      end

      sig { override.params(socket: IO).returns(T.attached_class) }
      def self.parse(socket)
        new socket
          .readline
          .chomp
      end
    end
  end
end
