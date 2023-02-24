# frozen_string_literal: true

require "delegate"
require "logger"

module Rediss
  class Logger < SimpleDelegator
    def initialize
      super(::Logger.new($stdout, formatter:))
    end

    def formatter
      proc do |severity, time, _progname, msg|
        abort("#{File.basename($PROGRAM_NAME)}: #{msg}".white.on_red) if severity == "FATAL"

        msg = "[#{time}] #{msg}\n"
        msg = msg.yellow if severity == "DEBUG"
        msg = msg.red if severity == "ERROR"

        msg
      end
    end
  end
end
