# frozen_string_literal: true
# typed: true

module Rediss
  class Spy < Application
    argument "--redis-host REDIS_HOST", "Host to connect to (Redis)"
    argument "--redis-port REDIS_PORT", Integer, "Port to connect to (Redis)"
    argument "--rediss-host REDISS_HOST", "Host to connect to (Rediss)"
    argument "--rediss-port REDISS_PORT", Integer, "Port to connect to (Rediss)"

    defaults redis_host: "127.0.0.1",
             redis_port: 6379,
             rediss_host: "127.0.0.1",
             rediss_port: 6378

    sig { void }
    def start
      Async do
        # Wrap sockets
        connections = [
          Connection.new(redis_socket, options),
          Connection.new(rediss_socket, options),
        ]

        Client::MultiHandler
          .new(connections)
          .start
      ensure
        connections&.each(&:close)
      end
    rescue Interrupt
      info "Shutting down client"
    end

    private

    sig { returns(Async::IO::TCPSocket) }
    def redis_socket
      @redis_socket ||= Async::IO::TCPSocket.new(options[:redis_host], options[:redis_port])
    end

    sig { returns(Async::IO::TCPSocket) }
    def rediss_socket
      @rediss_socket ||= Async::IO::TCPSocket.new(options[:rediss_host], options[:rediss_port])
    end
  end
end
