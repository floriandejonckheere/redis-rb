# frozen_string_literal: true
# typed: true

module Redis
  class Type
    extend T::Sig

    sig { returns(String) }
    def to_s
      raise NotImplementedError
    end

    sig { params(socket: IO).returns(Redis::Type) }
    def self.parse(socket)
      raise NotImplementedError
    end
  end
end
