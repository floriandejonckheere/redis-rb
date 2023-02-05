# frozen_string_literal: true

module Redis
  module Types
    class Parser
      TYPES = {
        # Simple types
        # "$" => BlobString,
        # "+" => SimpleString,
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
      }.freeze

      attr_reader :socket

      def initialize(socket)
        @socket = socket
      end

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
