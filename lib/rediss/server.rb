# frozen_string_literal: true
# typed: true

require "async/io/tcp_socket"

module Rediss
  class Server < Application
    option "-h", "--host HOST", "Host to bind to"
    option "-p", "--port PORT", Integer, "Port to bind to"
    option "-u", "--user USER", "User to use for authentication"
    option "-p", "--password PASSWORD", "Password to use for authentication"

    defaults host: "127.0.0.1",
             port: 6378,
             user: nil,
             password: nil

    sig { void }
    def start
      info "Starting server on #{options[:host]}:#{options[:port]}"

      Async do
        loop do
          socket, _address = server.accept

          Async do
            # Wrap socket
            connection = Connection.new(socket, options)

            Handler
              .new(connection)
              .start
          ensure
            connection&.close
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
