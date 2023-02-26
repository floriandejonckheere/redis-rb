# frozen_string_literal: true
# typed: true

module Rediss
  class Command
    extend T::Sig
    extend T::Helpers

    abstract!

    class_attribute :arity, default: 1

    sig { returns(T::Array[Rediss::Type]) }
    attr_reader :arguments

    sig { params(arguments: Rediss::Type).void }
    def initialize(arguments)
      @arguments = Array(arguments)
    end

    sig { abstract.returns(Rediss::Type) }
    def execute; end

    sig { returns(String) }
    def self.command_name
      T.cast(name, String).demodulize.underscore
    end
  end
end
