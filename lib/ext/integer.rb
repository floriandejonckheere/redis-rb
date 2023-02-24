# frozen_string_literal: true
# typed: true

require "redis/type"

class Integer
  include Redis::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    ":#{self}\r\n"
  end

  sig { override.params(type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    # Read value
    value = socket
      .gets
      .chomp

    # Convert to integer (using Kernel#Integer)
    Kernel.send(name&.to_sym || :Integer, value)
  end
end
