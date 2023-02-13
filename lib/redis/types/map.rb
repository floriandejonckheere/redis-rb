# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class Map < Type
      sig { returns(T::Hash[Redis::Type, Redis::Type]) }
      attr_reader :value

      sig { params(value: T::Hash[Redis::Type, Redis::Type]).void }
      def initialize(value) # rubocop:disable Lint/MissingSuper
        @value = value
      end

      sig { override.returns(String) }
      def to_s
        "%#{value.count * 2}\r\n#{value.flat_map { |k, v| [k.to_s, v.to_s] }.join}"
      end

      sig { override.params(socket: Socket).returns(T.attached_class) }
      def self.parse(socket)
        # Read number of elements in map
        count = socket.gets.chomp.to_i

        # Read elements
        elements = ::Array.new(count) do
          Parser
            .new(socket)
            .read
        end

        # Convert to pair-wise array, and then to hash
        hash = elements
          .each_slice(2)
          .to_h

        new hash
      end
    end
  end
end
