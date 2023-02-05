# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class BlobString < Type
      sig { returns(String) }
      attr_reader :value

      sig { params(value: String).void }
      def initialize(value) # rubocop:disable Lint/MissingSuper
        @value = value
      end

      sig { override.returns(String) }
      def to_s
        "$#{value.length}\r\n#{value}\r\n"
      end

      sig { override.params(socket: Socket).returns(T.attached_class) }
      def self.parse(socket)
        # Read number of characters in blob string
        count = socket.gets.chomp.to_i

        new socket.read(count + 2).chomp
      end
    end
  end
end
