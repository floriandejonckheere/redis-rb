# frozen_string_literal: true
# typed: true

require "async/io/tcp_socket"

module Rediss
  class Server < Application
    argument "-h", "--host HOST", "Host to bind to"
    argument "-p", "--port PORT", Integer, "Port to bind to"

    defaults host: "127.0.0.1",
             port: 6378

    sig { void }
    def start
      info "Starting server on #{options[:host]}:#{options[:port]}"

      Async do
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
    rescue Interrupt
      info "Shutting down server"
    end

    private

    sig { returns(Async::IO::TCPServer) }
    def server
      @server ||= Async::IO::TCPServer.new(options[:host], options[:port])
    end
  end
end
