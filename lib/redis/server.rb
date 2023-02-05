# frozen_string_literal: true

require "async/io/tcp_socket"

module Redis
  class Server
    attr_reader :options

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
