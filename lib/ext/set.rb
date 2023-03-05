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

  sig { override.params(indent: Integer).returns(String) }
  def to_pretty_s(indent: 0)
    return "(empty set)" if empty?

    max_length = count.to_s.length

    # First, indent each element. Then, right justify the index of each element by the maximum length of the index.
    # Then, pretty print the value recursively and replace the newlines with spaces (normal indent plus right justify
    # of array indices: maximum length of the index plus the parenthesis plus a space).
    each_with_index
      .map { |e, i| "#{INDENT * indent}#{i.to_s.rjust(max_length)}) #{e.to_pretty_s.gsub(/\n/, "\n#{INDENT * indent}#{' ' * (max_length + 2)}")}" }
      .join("\n")
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
