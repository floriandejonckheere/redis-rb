# frozen_string_literal: true
# typed: true

module Redis
  class Command
    extend T::Sig
    extend T::Helpers

    abstract!

    sig { returns(T::Array[Redis::Type]) }
    attr_reader :arguments

    sig { params(arguments: Redis::Type).void }
    def initialize(arguments)
      @arguments = Array(arguments)
    end

    sig { abstract.returns(Redis::Type) }
    def execute; end
  end
end
