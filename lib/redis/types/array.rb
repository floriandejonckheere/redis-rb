# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class Array < Type
      sig { returns(T::Array[Redis::Type]) }
      attr_reader :elements

      sig { params(elements: T::Array[Redis::Type]).void }
      def initialize(elements)
        @elements = elements
      end

      sig { returns(String) }
      def to_s
        "*#{elements.count}\r\n#{elements.map(&:to_s).join}"
      end

      sig { params(socket: IO).returns(T.attached_class) }
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
