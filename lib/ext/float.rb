# frozen_string_literal: true
# typed: true

require "rediss/type"

class Float
  include Rediss::Type

  extend T::Sig

  sig { override.returns(String) }
  def to_resp3
    ",#{'-' if negative?}#{infinite? || nan? ? abs.to_s.downcase[0..2] : self}\r\n"
  end

  sig { override.params(indent: Integer).returns(String) }
  def to_pretty_s(indent: 0)
    "(float) #{self}"
  end

  sig { override.params(type: String, connection: Rediss::Connection, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
  def self.from_resp3(type, connection, &block)
    # Read value
    value = connection
      .gets
      .chomp

    case value.downcase
    when "inf"
      INFINITY
    when "-inf"
      -INFINITY
    when "nan"
      NAN
    else
      # Convert to float (using Kernel#Float)
      Kernel.send(name&.to_sym || :Float, value)
    end
  end
end
