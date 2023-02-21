# frozen_string_literal: true
# typed: true

class Float
  extend T::Sig

  sig { returns(String) }
  def to_resp3
    ",#{'-' if negative?}#{infinite? || nan? ? abs.to_s.downcase[0..2] : self}\r\n"
  end

  sig { params(_type: String, socket: Redis::Socket).returns(T.attached_class) }
  def self.from_resp3(_type, socket)
    # Read value
    value = socket
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
