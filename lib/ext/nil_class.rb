# frozen_string_literal: true
# typed: true

class NilClass
  extend T::Sig

  sig { returns(String) }
  def to_resp3
    "_\r\n"
  end

  sig { params(_type: String, socket: Redis::Socket).returns(T.attached_class) }
  def self.from_resp3(_type, socket)
    # Read until end of line
    socket.gets

    # Return nil
    nil
  end
end
