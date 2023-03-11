# frozen_string_literal: true
# typed: true

require "logger"

module Rediss
  class Application
    extend T::Sig
    extend T::Helpers
    include Options

    abstract!

    option("--log-level LOG_LEVEL", "Set log level") { |level| logger.level = Logger.const_get(level.upcase) }

    sig { params(args: T::Array[String]).void }
    def initialize(args)
      # Parse command-line arguments
      self.class.parser.parse!(args, into: options)

      # Set log level to debug in development
      logger.level = Logger::DEBUG if ENV["ENV"] == "development"
    end

    sig { abstract.void }
    def start; end
  end
end
