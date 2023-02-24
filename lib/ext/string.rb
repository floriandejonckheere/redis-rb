# frozen_string_literal: true
# typed: true

require "redis/type"

class String
  include Redis::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    "$#{length}\r\n#{self}\r\n"
  end

  sig { override.params(type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    case type
    when "$"
      # Read number of characters in blob string
      count = socket.gets.chomp.to_i

      # Read string characters
      new socket.read(count + 2).chomp
    when "="
      # Read number of characters in verbatim string
      count = socket.gets.chomp.to_i

      # Read format of verbatim string
      # TODO: return format to user
      socket.read(3)

      # Read separator
      socket.read(1)

      # Read string characters (without format and separator)
      new socket.read(count - 4 + 2).chomp
    when "+"
      # Read string characters
      new socket.gets.chomp
    else
      raise ArgumentError, "unknown type '#{type}'"
    end
  end
end
