# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class SimpleError < Type
      sig { returns(String) }
      attr_reader :value

      sig { params(value: String).void }
      def initialize(value) # rubocop:disable Lint/MissingSuper
        @value = value
      end

      sig { override.returns(String) }
      def to_s
        "-ERR #{value}\r\n"
      end

      sig { override.params(socket: IO).returns(T.attached_class) }
      def self.parse(socket)
        new socket
          .readline
          .chomp
          .delete_prefix("ERR ")
      end
    end
  end
end
