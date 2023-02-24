# frozen_string_literal: true
# typed: true

require "redis/type"

class Array
  include Redis::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    "*#{count}\r\n#{map { |e| T.cast(e, Redis::Type).to_resp3 }.join}"
  end

  sig { override.params(type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    # Read number of elements in array
    count = socket.gets.chomp.to_i

    # Read elements
    count.times.map(&block)
  end
end
