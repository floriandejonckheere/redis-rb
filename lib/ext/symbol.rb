# frozen_string_literal: true
# typed: true

require "rediss/type"

class Symbol
  include Rediss::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    "$#{length}\r\n#{self}\r\n"
  end

  sig { override.params(type: String, socket: Rediss::Socket, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    raise ArgumentError, "cannot deserialize symbols"
  end
end
