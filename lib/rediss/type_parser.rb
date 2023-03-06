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

    sig { returns(Connection) }
    attr_reader :connection

    sig { params(connection: Connection).void }
    def initialize(connection)
      @connection = connection
    end

    sig { returns(Rediss::Type) }
    def read
      type = connection.read(1)

      return unless type

      TYPES
        .fetch(type)
        .from_resp3(type, connection) { read }
    rescue KeyError => e
      raise ArgumentError, "unknown type '#{e.key}'"
    end
  end
end
