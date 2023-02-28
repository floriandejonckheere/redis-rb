# frozen_string_literal: true
# typed: true

require "rediss/type"

class Hash
  include Rediss::Type

  extend T::Sig

  sig { returns(T::Array[Rediss::Type]) }
  def deep_flatten
    transform_values { |v| T.cast(v, ActiveSupport::Tryable).try(:deep_flatten) || v }.flatten
  end

  sig { override.returns(String) }
  def to_resp3
    "%#{count * 2}\r\n#{flat_map { |k, v| [T.cast(k, Rediss::Type).to_resp3, T.cast(v, Rediss::Type).to_resp3] }.join}"
  end

  sig { override.params(type: String, socket: Rediss::Socket, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
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
