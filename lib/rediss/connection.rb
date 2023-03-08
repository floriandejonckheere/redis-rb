# frozen_string_literal: true
# typed: true

require "async/io/tcp_socket"

module Rediss
  class Connection
    extend T::Sig

    # Adapter type for StringIO (used in specs) and Async::IO::TCPSocket (used at runtime)
    # Neither classes actually inherit from IO
    ConnectionType = T.type_alias { T.any(StringIO, Async::IO::TCPSocket) }

    sig { returns(ConnectionType) }
    attr_reader :io

    sig { returns(T::Hash[Symbol, T.untyped]) }
    attr_reader :options

    sig { returns(Database) }
    attr_reader :database

    sig { returns(T.nilable(String)) }
    attr_accessor :name

    sig { params(io: ConnectionType, options: T::Hash[Symbol, T.untyped], database: Database).void }
    def initialize(io, options = {}, database = Database[0])
      @io = io
      @options = options
      @database = database
    end

    def authenticate(username, password)
      return true unless options[:username] && options[:password]

      options[:username] == username && options[:password] == password
    end

    def select(index)
      @database = Database[index]
    end

    def address
      @address ||= "#{peeraddr[3]}:#{peeraddr[1]}"
    end

    delegate :gets,
             :read,
             :write,
             :peeraddr,
             :close,
             to: :io
  end
end
