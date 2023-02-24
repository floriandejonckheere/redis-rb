# frozen_string_literal: true
# typed: true

require "redis/type"

class Hash
  include Redis::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    "%#{count * 2}\r\n#{flat_map { |k, v| [T.cast(k, Redis::Type).to_resp3, T.cast(v, Redis::Type).to_resp3] }.join}"
  end

  sig { override.params(type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    # Read number of elements in hash
    count = socket.gets.chomp.to_i

    # Read elements
    elements = count.times.map(&block)

    # Convert to pair-wise array, and then to hash
    elements
      .each_slice(2)
      .with_object(new) { |(k, v), hash| hash[k] = v }
  end
end
