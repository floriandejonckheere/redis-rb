# frozen_string_literal: true

require "logger"

require "async"
require "async/io"
require "active_support/all"
require "sorbet-runtime"
require "zeitwerk"

module Rediss
  class << self
    attr_reader :loader

    def root
      @root ||= Pathname.new(File.expand_path(File.join("..", ".."), __FILE__))
    end

    def logger
      @logger ||= Logger.new
    end

    def setup
      @loader = Zeitwerk::Loader.new

      # Add root directories
      loader.push_dir(root.join("lib"))
      loader.push_dir(root.join("lib/ext"))

      # Load extensions
      Dir[root.join("lib/ext/**/*.rb")].each { |file| require file }

      # Register inflections
      instance_eval(File.read(root.join("config/inflections.rb")))

      # Set up code loader
      loader.enable_reloading
      loader.setup
      loader.eager_load
    end
  end
end

Rediss.setup