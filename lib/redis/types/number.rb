# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class Number < Type
      sig { returns(Integer) }
      attr_reader :value

      sig { params(value: Integer).void }
      def initialize(value) # rubocop:disable Lint/MissingSuper
        @value = value
      end

      sig { override.returns(String) }
      def to_s
        ":#{value}\r\n"
      end

      sig { override.params(socket: IO).returns(T.attached_class) }
      def self.parse(socket)
        new socket
          .readline
          .chomp
          .to_i
      end
    end
  end
end
