# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class Parser
      extend T::Sig

      TYPES = T.let({
        # Simple types
        "$" => BlobString,
        "+" => SimpleString,
        "-" => SimpleError,
        ":" => Number,
        # "_" => Null,
        # "," => Double,
        # "#" => Boolean,
        # "!" => BlobError,
        # "=" => VerbatimString,
        # "(" => BigNumber,

        # Aggregate types
        "*" => Array,
        "%" => Map,
        # "~" => Set,
        # "|" => Attribute,
      }.freeze, T::Hash[T.nilable(String), T.class_of(Redis::Type)],)

      sig { returns(Socket) }
      attr_reader :socket

      sig { params(socket: Socket).void }
      def initialize(socket)
        @socket = socket
      end

      sig { returns(T.nilable(Redis::Type)) }
      def read
        type = socket.read(1)

        return unless type

        TYPES
          .fetch(type)
          .parse(socket)
      rescue KeyError => e
        raise ArgumentError, "unknown type '#{e.key}'"
      end
    end
  end
end
