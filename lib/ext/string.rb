# frozen_string_literal: true
# typed: true

require "rediss/type"

class String
  include Rediss::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    "$#{length}\r\n#{self}\r\n"
  end

  sig { override.params(indent: Integer).returns(String) }
  def to_pretty_s(indent: 0)
    inspect
  end

  sig { override.params(type: String, connection: Rediss::Connection, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
  def self.from_resp3(type, connection, &block)
    case type
    when "$"
      # Read number of characters in blob string
      count = connection.gets.chomp.to_i

      # Read string characters
      new connection.read(count + 2).chomp
    when "="
      # Read number of characters in verbatim string
      count = connection.gets.chomp.to_i

      # Read format of verbatim string
      # TODO: return format to user
      connection.read(3)

      # Read separator
      connection.read(1)

      # Read string characters (without format and separator)
      new connection.read(count - 4 + 2).chomp
    when "+"
      # Read string characters
      new connection.gets.chomp
    else
      raise ArgumentError, "unknown type '#{type}'"
    end
  end
end
