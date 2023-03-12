# frozen_string_literal: true
# typed: true

module Rediss
  module HasChildren
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :child_name

      def children
        @children ||= {}
      end

      def child(child_name)
        # Set child name
        self.child_name = child_name

        # Register class as child of the parent class
        superclass&.children&.[]=(child_name, self)

        nil
      end
    end
  end
end
