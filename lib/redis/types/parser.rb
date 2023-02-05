# frozen_string_literal: true
# typed: true

module Redis
  module Types
    class Parser
      extend T::Sig

      TYPES = T.let({
        # Simple types
        # "$" => BlobString,
        "+" => SimpleString,
        "-" => SimpleError,
        # ":" => Number,
        # "_" => Null,
        # "," => Double,
        # "#" => Boolean,
        # "!" => BlobError,
        # "=" => VerbatimString,
        # "(" => BigNumber,

        # Aggregate types
        # "*" => Array,
        # "%" => Map,
        # "~" => Set,
        # "|" => Attribute,
      }.freeze, T::Hash[T.nilable(String), T.class_of(Redis::Type)],)

      sig { returns(IO) }
      attr_reader :socket

      sig { params(socket: IO).void }
      def initialize(socket)
        @socket = socket
      end

      sig { returns(Redis::Type) }
      def read
        type = socket.read(1)

        TYPES
          .fetch(type)
          .parse(socket)
      rescue KeyError => e
        SimpleError.new("unknown command '#{e.key}'")
      end
    end
  end
end
