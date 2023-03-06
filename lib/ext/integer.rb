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

  sig { override.params(indent: Integer).returns(String) }
  def to_pretty_s(indent: 0)
    "(integer) #{self}"
  end

  sig { override.params(type: String, connection: Rediss::Connection, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
  def self.from_resp3(type, connection, &block)
    # Read value
    value = connection
      .gets
      .chomp

    # Convert to integer (using Kernel#Integer)
    Kernel.send(name&.to_sym || :Integer, value)
  end
end
