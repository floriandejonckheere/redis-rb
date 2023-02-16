# frozen_string_literal: true
# typed: true

class String
  extend T::Sig

  sig { returns(String) }
  def to_resp3
    "$#{length}\r\n#{self}\r\n"
  end

  sig { params(type: String, socket: Redis::Socket).returns(T.attached_class) }
  def self.from_resp3(type, socket)
    case type
    when "$"
      # Read number of characters in blob string
      count = socket.gets.chomp.to_i

      # Read string characters
      new socket.read(count + 2).chomp
    when "+"
      # Read string characters
      new socket.gets.chomp
    else
      raise ArgumentError, "unknown type '#{type}'"
    end
  end
end
