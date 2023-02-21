# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class Parser
      extend T::Sig

      TYPES = T.let({
        # Simple types
        "$" => String,
        "+" => String,
        "-" => Error,
        ":" => Integer,
        "_" => NilClass,
        "," => Float,
        "#" => TrueClass,
        "!" => Error,
        "=" => String,
        # "(" => BigNumber,

        # Aggregate types
        "*" => Array,
        "%" => Hash,
        "~" => Set,
        # "|" => Attribute,
      }.freeze, T::Hash[T.nilable(String), T.class_of(Redis::Type)],)

      sig { returns(Socket) }
      attr_reader :socket

      sig { params(socket: Socket).void }
      def initialize(socket)
        @socket = socket
      end

      sig { returns(Redis::Type) }
      def read
        type = socket.read(1)

        return unless type

        TYPES
          .fetch(type)
          .from_resp3(type, socket) { read }
      rescue KeyError => e
        raise ArgumentError, "unknown type '#{e.key}'"
      end
    end
  end
end
