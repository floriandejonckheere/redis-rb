# frozen_string_literal: true

require "logger"

require "async"
require "async/io"
require "active_support/all"
require "zeitwerk"

module Redis
  class << self
    attr_reader :loader

    def root
      @root ||= Pathname.new(File.expand_path(File.join("..", ".."), __FILE__))
    end

    def logger
      @logger ||= Logger.new
    end

    def setup
      @loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)

      # Register inflections
      instance_eval(File.read(root.join("config/inflections.rb")))

      # Set up code loader
      loader.enable_reloading
      loader.setup
      loader.eager_load
    end
  end
end

Redis.setup
