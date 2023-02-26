# frozen_string_literal: true
# typed: true

require "singleton"
require "delegate"

module Rediss
  class Registry
    extend T::Sig

    include Singleton

    sig { returns(T::Hash[String, T.class_of(Rediss::Command)]) }
    attr_reader :commands

    sig { void }
    def initialize
      @commands = {}
    end

    sig { params(key: String, command: T.class_of(Rediss::Command)).void }
    def register(key, command)
      @commands[key] = command

      nil
    end

    class << self
      delegate :commands,
               :register,
               to: :instance
    end
  end
end
