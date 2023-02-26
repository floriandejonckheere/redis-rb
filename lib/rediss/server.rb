# frozen_string_literal: true
# typed: true

require "async/io/tcp_socket"

module Rediss
  class Server
    extend T::Sig

    sig { returns(T::Hash[Symbol, T.untyped]) }
    attr_reader :options

    sig { params(options: T::Hash[Symbol, T.untyped]).void }
    def initialize(options)
      @options = options
    end

    def start
      info "Starting server on #{options[:host]}:#{options[:port]}"

      loop do
        socket, _address = server.accept

        Async do
          # Wrap socket
          socket = Socket.new(socket)

          Handler
            .new(socket)
            .start
        ensure
          socket.close
        end
      end
    end

    private

    def server
      @server ||= Async::IO::TCPServer.new(options[:host], options[:port])
    end
  end
end
