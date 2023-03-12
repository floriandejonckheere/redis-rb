# frozen_string_literal: true

module Rediss
  module HasArguments
    extend ActiveSupport::Concern

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
        argument_definitions << Argument.children.fetch(type).new(name, flags:, **kwargs)
      end

      def parser
        @parser ||= Parser.new(argument_definitions)
      end
    end
  end
end
