# frozen_string_literal: true

require "English"
require "logger"
require "optparse"

module Rediss
  class CLI
    attr_reader :options

    def initialize(args)
      # Default options
      @options = {
        host: "127.0.0.1",
        port: 6379,
        verbose: false,
        quiet: false,
      }

      # Parse command-line arguments
      parser.parse!(args, into: @options)
    end

    def start
      logger.level = Logger::DEBUG if options[:verbose]
      logger.level = Logger::FATAL if options[:quiet]

      Async do
        Server
          .new(options)
          .start
      end
    rescue Interrupt
      info "Shutting down server"
    end

    private

    def parser
      @parser ||= OptionParser.new("#{File.basename($PROGRAM_NAME)} [options]") do |o|
        o.on("-v", "--verbose", "Turn on verbose logging")
        o.on("-q", "--quiet", "Turn off logging")
        o.on("-h", "--host HOST", "Host to bind to")
        o.on("-p", "--port PORT", Integer, "Port to bind to")

        o.on("--version", "Display application information") { abort("Rediss v#{Rediss::VERSION}") }
        o.on("--help", "Display this message") { abort(parser.to_s) }
      end
    end
  end
end
