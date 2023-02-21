# frozen_string_literal: true
# typed: true

module Boolean
  extend ActiveSupport::Concern
  extend T::Sig

  included do
    extend T::Sig

    sig { returns(String) }
    def to_resp3
      "##{self == true ? 't' : 'f'}\r\n"
    end

    sig { params(_type: String, socket: Redis::Socket).returns(T.attached_class) }
    def self.from_resp3(_type, socket)
      # Read value
      value = socket
        .gets
        .chomp

      value == "t"
    end
  end
end
