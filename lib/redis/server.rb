# frozen_string_literal: true
# typed: true

require "async/io/tcp_socket"

module Redis
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

      server.accept do |socket|
        socket = Socket.new(socket)

        Handler
          .new(socket)
          .start
      end
    end

    private

    def server
      @server ||= Async::IO::TCPServer.new(options[:host], options[:port])
    end
  end
end
