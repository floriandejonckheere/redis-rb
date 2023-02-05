# frozen_string_literal: true
# typed: true

module Redis
  class Type
    extend T::Sig

    attr_reader :value

    def initialize(value)
      @value = value
    end

    sig { returns(String) }
    def to_s
      raise NotImplementedError
    end

    sig { params(socket: IO).returns(T.attached_class) }
    def self.parse(socket)
      raise NotImplementedError
    end
  end
end
