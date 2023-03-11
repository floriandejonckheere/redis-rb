# frozen_string_literal: true

module Rediss
  module Options
    extend ActiveSupport::Concern

    included do
      class_attribute :default_options,
                      default: {}

      class_attribute :option_definitions,
                      default: []

      def options
        @options ||= self.class.default_options.dup
      end
    end

    class_methods do
      def inherited(base)
        super(base)

        base.default_options = default_options.clone
        base.option_definitions = option_definitions.clone
      end

      def defaults(**options)
        default_options.merge!(options)
      end

      def option(*args, &block)
        option_definitions << [args, block]
      end

      def parser
        @parser ||= OptionParser.new("#{File.basename($PROGRAM_NAME)} [options]") do |o|
          option_definitions.each { |args, block| o.on(*args, &block) }

          o.on("--version", "Display application information") { abort("Rediss v#{Rediss::VERSION}") }
          o.on("--help", "Display this message") { abort(parser.to_s) }
        end
      end
    end
  end
end
