# frozen_string_literal: true

module Rediss
  module HasArguments
    extend ActiveSupport::Concern

    TYPES = {
      key: Arguments::Key,
      string: Arguments::String,
    }.freeze

    included do
      class_attribute :argument_definitions,
                      default: []

      def options
        @options ||= {}
      end
    end

    class_methods do
      def inherited(base)
        super(base)

        base.argument_definitions = argument_definitions.clone
      end

      def argument(name, type:, flags: [], **kwargs)
        argument_definitions << TYPES.fetch(type).new(name, flags:, **kwargs)
      end

      def parser
        @parser ||= Parser.new(argument_definitions)
      end
    end
  end
end
