# frozen_string_literal: true
# typed: true

require "redis/type"

module Boolean
  include Redis::Type

  extend ActiveSupport::Concern
  extend T::Sig

  included do
    extend T::Sig

    sig { override.returns(String) }
    def to_resp3
      "##{self == true ? 't' : 'f'}\r\n"
    end

    sig { override.params(type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.attached_class) }
    def self.from_resp3(type, socket, &block)
      # Read value
      value = socket
        .gets
        .chomp

      value == "t"
    end
  end
end
