# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class Array < Type
      sig { returns(T::Array[Redis::Type]) }
      attr_reader :value

      sig { params(value: T::Array[Redis::Type]).void }
      def initialize(value)
        @value = value
      end

      sig { override.returns(String) }
      def to_s
        "*#{value.count}\r\n#{value.map(&:to_s).join}"
      end

      sig { override.params(socket: IO).returns(T.attached_class) }
      def self.parse(socket)
        # Read number of elements in array
        count = socket.readline.chomp.to_i

        elements = count.times.map do
          Parser
            .new(socket)
            .read
        end

        new elements
      end
    end
  end
end
