# frozen_string_literal: true
# typed: true

module Redis
  class Command
    extend T::Sig
    extend T::Helpers

    abstract!

    sig { returns(T.nilable(Redis::Types::Array)) }
    attr_reader :arguments

    sig { params(arguments: T.nilable(Redis::Types::Array)).void }
    def initialize(arguments)
      @arguments = arguments
    end

    sig { abstract.returns(Redis::Type) }
    def execute; end
  end
end
