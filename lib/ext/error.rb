# frozen_string_literal: true
# typed: true

puts "loaded Error"

class Error
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

  sig { returns(String) }
  def to_resp3
    "!#{code.length + 1 + message.length}\r\n#{code} #{message}\r\n"
  end

  sig { params(socket: Redis::Socket).returns(T.attached_class) }
  def self.from_resp3(socket)
    # Read error type
    type = socket.read(1)

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
