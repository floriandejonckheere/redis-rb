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
      Float::INFINITY
    when "-inf"
      -Float::INFINITY
    when "nan"
      Float::NAN
    else
      Float value
    end
  end
end
