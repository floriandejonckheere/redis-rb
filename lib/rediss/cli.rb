# frozen_string_literal: true
# typed: true

require "English"
require "logger"
require "optparse"

module Rediss
  class CLI
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
    end

    sig { void }
    def start
      logger.level = options[:log_level]

      Async do
        Server
          .new(options)
          .start
      end
    rescue Interrupt
      info "Shutting down server"
    end

    private

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
