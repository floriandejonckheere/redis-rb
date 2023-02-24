# frozen_string_literal: true
# typed: true

require "redis/type"

class NilClass
  include Redis::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    "_\r\n"
  end

  # Returns untyped because Sorbet is giving a cryptic error when trying to use `T.attached_class`
  sig { override.params(type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.untyped) }
  def self.from_resp3(type, socket, &block)
    # Read until end of line
    socket.gets

    # Return nil
    nil
  end
end
