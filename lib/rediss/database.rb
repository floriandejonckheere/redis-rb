# frozen_string_literal: true
# typed: true

module Rediss
  class Database
    extend T::Sig

    sig { returns(Integer) }
    attr_reader :index

    sig { returns(T::Hash[String, Entry]) }
    attr_reader :entries

    sig { params(index: Integer).void }
    def initialize(index)
      @index = index
      @entries = Hash.new { |hash, key| hash[key] = Entry.new }
    end

    sig { params(key: String).returns(Entry) }
    def get(key)
      T.cast(entries[key], Rediss::Entry)
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
