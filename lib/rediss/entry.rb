# frozen_string_literal: true
# typed: true

module Rediss
  class Entry
    extend T::Sig

    sig { returns(Rediss::Type) }
    attr_accessor :value

    def initialize(value = nil)
      @value = value
    end

    def string?
      value&.is_a?(String)
    end
  end
end
