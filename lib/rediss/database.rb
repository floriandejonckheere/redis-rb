# frozen_string_literal: true
# typed: true

module Rediss
  class Database
    extend T::Sig

    sig { returns(Integer) }
    attr_reader :index

    sig { params(index: Integer).void }
    def initialize(index)
      @index = index
    end

    sig { returns(T::Hash[Integer, Database]) }
    def self.databases
      @databases ||= Hash.new { |hash, key| hash[key] = new(key) }
    end

    class << self
      delegate :[],
               to: :databases
    end
  end
end
