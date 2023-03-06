# frozen_string_literal: true
# typed: true

require "async/io/tcp_socket"

module Rediss
  class Connection
    extend T::Sig

    # Adapter type for IO (used in specs) and Async::IO::TCPSocket (used at runtime)
    # Neither classes actually inherit from IO
    ConnectionType = T.type_alias { T.any(IO, Async::IO::TCPSocket) }

    sig { returns(ConnectionType) }
    attr_reader :io

    sig { params(io: ConnectionType).void }
    def initialize(io)
      @io = io
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
