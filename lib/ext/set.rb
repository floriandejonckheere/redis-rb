# frozen_string_literal: true
# typed: true

class Set
  extend T::Sig

  sig { returns(String) }
  def to_resp3
    "~#{count}\r\n#{map(&:to_resp3).join}"
  end

  sig { params(_type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.attached_class) }
  def self.from_resp3(_type, socket, &block)
    # Read number of elements in set
    count = socket.gets.chomp.to_i

    # Read elements
    new(Array.new(count, &block))
  end
end
