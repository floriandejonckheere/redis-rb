# frozen_string_literal: true
# typed: true

require "rediss/type"

class Error
  include Rediss::Type

  extend T::Sig

  sig { returns(String) }
  attr_reader :code

  sig { returns(String) }
  attr_reader :message

  sig { params(code: String, message: String).void }
  def initialize(code, message)
    @code = code
    @message = message
  end

  sig { override.returns(String) }
  def to_resp3
    "!#{code.length + 1 + message.length}\r\n#{code} #{message}\r\n"
  end

  sig { override.params(indent: Integer).returns(String) }
  def to_pretty_s(indent: 0)
    "#{code} #{message}"
  end

  sig { override.params(type: String, socket: Rediss::Socket, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    case type
    when "!"
      # Read number of characters in blob error
      count = socket.gets.chomp.to_i

      # Read error characters
      code, *message = socket.read(count + 2).chomp.split
    when "-"
      # Read error characters
      code, *message = socket.gets.chomp.split
    else
      raise ArgumentError, "unknown type '#{type}'"
    end

    new(code, message.join(" "))
  end
end
