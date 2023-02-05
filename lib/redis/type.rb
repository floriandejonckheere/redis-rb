# frozen_string_literal: true
# typed: true

module Redis
  class Type
    extend T::Sig
    extend T::Helpers

    abstract!

    attr_reader :value

    def initialize(value)
      @value = value
    end

    sig { abstract.returns(String) }
    def to_s; end

    sig { abstract.params(socket: Socket).returns(T.attached_class) }
    def self.parse(socket); end
  end
end
