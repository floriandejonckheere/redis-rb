# frozen_string_literal: true
# typed: true

module Rediss
  class Client < Application
    argument "-h", "--host HOST", "Host to connect to"
    argument "-p", "--port PORT", Integer, "Port to connect to"

    defaults host: "127.0.0.1",
             port: 6378

    sig { void }
    def start
      Async do
        # Wrap socket
        connection = Connection.new(socket)

        Handler
          .new(connection)
          .start
      ensure
        connection&.close
      end
    rescue Interrupt
      info "Shutting down client"
    end

    private

    sig { returns(Async::IO::TCPSocket) }
    def socket
      @socket ||= Async::IO::TCPSocket.new(options[:host], options[:port])
    end
  end
end
