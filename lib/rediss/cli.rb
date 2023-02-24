# frozen_string_literal: true

require "optparse"
require "English"

module Rediss
  class CLI
    attr_reader :options

    def initialize(args)
      # Default options
      @options = {
        host: "127.0.0.1",
        port: 6379,
        verbose: false,
      }

      # Parse command-line arguments
      parser.parse!(args, into: @options)
    end

    def start
      Async do
        Server
          .new(options)
          .start
      end
    end

    private

    def parser
      @parser ||= OptionParser.new("#{File.basename($PROGRAM_NAME)} [options]") do |o|
        o.on("-v", "--verbose", "Turn on verbose logging")
        o.on("-h", "--host HOST", "Host to bind to")
        o.on("-p", "--port PORT", Integer, "Port to bind to")

        o.on("--help", "Display this message") { abort(parser.to_s) }
      end
    end
  end
end
