# frozen_string_literal: true
# typed: true

require "English"
require "logger"
require "optparse"

module Rediss
  class Application
    extend T::Sig
    include Arguments

    argument("--log-level LOG_LEVEL", "Set log level") { |level| logger.level = Logger.const_get(level.upcase) }

    sig { params(args: T::Array[String]).void }
    def initialize(args)
      # Parse command-line arguments
      self.class.parser.parse!(args, into: options)
    end
  end
end
