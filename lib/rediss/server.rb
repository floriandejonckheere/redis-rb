# frozen_string_literal: true
# typed: true

require "English"
require "logger"
require "optparse"

require "async/io/tcp_socket"

module Rediss
  class Server
    extend T::Sig

    sig { returns(T::Hash[Symbol, T.untyped]) }
    attr_reader :options

    sig { params(args: T::Array[String]).void }
    def initialize(args)
      # Default options
      @options = {
        host: "127.0.0.1",
        port: 6379,
        log_level: Logger::INFO,
      }

      # Parse command-line arguments
      parser.parse!(args, into: @options)

      # Set log level
      logger.level = options[:log_level]
    end

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

    sig { returns(OptionParser) }
    def parser
      @parser ||= OptionParser.new("#{File.basename($PROGRAM_NAME)} [options]") do |o|
        o.on("--log-level LOG_LEVEL") { |level| options[:log_level] = Logger.const_get(level.upcase) }
        o.on("-h", "--host HOST", "Host to bind to")
        o.on("-p", "--port PORT", Integer, "Port to bind to")

        o.on("--version", "Display application information") { abort("Rediss v#{Rediss::VERSION}") }
        o.on("--help", "Display this message") { abort(parser.to_s) }
      end
    end
  end
end
