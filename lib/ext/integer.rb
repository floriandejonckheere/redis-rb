# frozen_string_literal: true
# typed: true

class Integer
  extend T::Sig

  sig { returns(String) }
  def to_resp3
    ":#{self}\r\n"
  end

  sig { params(_type: String, socket: Redis::Socket).returns(T.attached_class) }
  def self.from_resp3(_type, socket)
    Integer socket
      .gets
      .chomp
  end
end
