# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class Number < Type
      sig { returns(Integer) }
      attr_reader :value

      sig { params(value: Integer).void }
      def initialize(value)
        @value = value
      end

      sig { returns(String) }
      def to_s
        ":#{value}\r\n"
      end

      sig { params(socket: IO).returns(T.attached_class) }
      def self.parse(socket)
        new socket
          .readline
          .chomp
          .to_i
      end
    end
  end
end
