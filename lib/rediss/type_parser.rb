# frozen_string_literal: true
# typed: true

module Rediss
  class TypeParser
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
      "(" => Integer,

      # Aggregate types
      "*" => Array,
      "%" => Hash,
      "~" => Set,
      "|" => Attribute,
    }.freeze, T::Hash[String, T.untyped],)

    sig { returns(Socket) }
    attr_reader :socket

    sig { params(socket: Socket).void }
    def initialize(socket)
      @socket = socket
    end

    sig { returns(Rediss::Type) }
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
