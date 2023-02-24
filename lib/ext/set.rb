# frozen_string_literal: true
# typed: true

require "rediss/type"

class Set
  include Rediss::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    "~#{count}\r\n#{map { |e| T.cast(e, Rediss::Type).to_resp3 }.join}"
  end

  sig { override.params(type: String, socket: Rediss::Socket, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    # Read number of elements in set
    count = socket.gets.chomp.to_i

    # Read elements
    elements = count.times.map(&block)

    # Convert to set
    new elements
  end
end
