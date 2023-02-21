# frozen_string_literal: true
# typed: true

class Attribute < Hash
  extend T::Sig

  sig { returns(String) }
  def to_resp3
    "|#{count * 2}\r\n#{flat_map { |k, v| [k.to_resp3, v.to_resp3] }.join}"
  end

  sig { params(_type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.attached_class) }
  def self.from_resp3(_type, socket, &block)
    # Read number of elements in attribute
    count = socket.gets.chomp.to_i

    # Read elements
    elements = Array.new(count, &block)

    # Convert to pair-wise array, and then to hash
    hash = elements
      .each_slice(2)
      .to_h

    # Convert to attribute
    self[hash]
  end
end
