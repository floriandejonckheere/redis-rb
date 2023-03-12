# frozen_string_literal: true
# typed: true

module Rediss
  class Argument
    extend T::Sig

    sig { returns(::Symbol) }
    attr_reader :name

    sig { returns(T::Array[::Symbol]) }
    attr_reader :flags

    sig { params(name: ::Symbol, flags: T::Array[::Symbol], kwargs: T::Hash[::Symbol, T.untyped]).void }
    def initialize(name, flags: [], **kwargs)
      @name = name
      @flags = flags
    end

    sig { params(argument: Rediss::Type).returns(Rediss::Type) }
    def parse(argument)
      argument
    end

    sig { returns(::Boolean) }
    def optional?
      flags.include? :optional
    end

    sig { returns(::Boolean) }
    def required?
      !optional?
    end
  end
end
