# frozen_string_literal: true
# typed: true

module Rediss
  # Adapter class for IO (used in specs) and Async::IO::TCPSocket (used at runtime)
  # Neither classes actually inherit from IO
  class Socket
    extend T::Sig

    SocketType = T.type_alias { T.any(IO, Async::IO::TCPSocket) }

    sig { returns(SocketType) }
    attr_reader :io

    sig { params(io: SocketType).void }
    def initialize(io)
      @io = io
    end

    delegate :gets,
             :read,
             :write,
             :peeraddr,
             to: :io
  end
end
