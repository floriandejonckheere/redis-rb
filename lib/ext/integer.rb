# frozen_string_literal: true
# typed: true

require "rediss/type"

class Integer
  include Rediss::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    ":#{self}\r\n"
  end

  sig { override.params(type: String, socket: Rediss::Socket, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
  def self.from_resp3(type, socket, &block)
    # Read value
    value = socket
      .gets
      .chomp

    # Convert to integer (using Kernel#Integer)
    Kernel.send(name&.to_sym || :Integer, value)
  end
end
