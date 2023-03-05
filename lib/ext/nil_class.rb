# frozen_string_literal: true
# typed: true

require "rediss/type"

class NilClass
  include Rediss::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    "_\r\n"
  end

  sig { override.params(indent: Integer).returns(String) }
  def to_pretty_s(indent: 0)
    "(nil)"
  end

  # Returns untyped because Sorbet is giving a cryptic error when trying to use `T.attached_class`
  sig { override.params(type: String, socket: Rediss::Socket, block: T.proc.returns(Rediss::Type)).returns(T.untyped) }
  def self.from_resp3(type, socket, &block)
    # Read until end of line
    socket.gets

    # Return nil
    nil
  end
end
