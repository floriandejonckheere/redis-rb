# frozen_string_literal: true
# typed: true

require "rediss/type"

class Array
  include Rediss::Type

  extend T::Sig

  sig { returns(T::Array[Rediss::Type]) }
  def deep_flatten
    map { |e| T.cast(e, ActiveSupport::Tryable).try(:deep_flatten) || e }
  end

  sig { override.returns(String) }
  def to_resp3
    "*#{count}\r\n#{map { |e| T.cast(e, Rediss::Type).to_resp3 }.join}"
  end

  sig { override.params(type: String, socket: Rediss::Socket, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    # Read number of elements in array
    count = socket.gets.chomp.to_i

    # Read elements
    count.times.map(&block)
  end
end
