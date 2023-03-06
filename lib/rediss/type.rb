# frozen_string_literal: true
# typed: true

module Rediss
  module Type
    include Kernel
    extend T::Sig
    extend T::Helpers

    # Indentation for pretty printing
    INDENT = "  "

    interface!

    sig { abstract.returns(String) }
    def to_resp3; end

    sig { abstract.params(indent: Integer).returns(String) }
    def to_pretty_s(indent: 0); end

    module ClassMethods
      extend T::Sig
      extend T::Helpers

      interface!

      sig { abstract.params(type: String, socket: Rediss::Socket, block: T.proc.returns(Rediss::Type)).returns(T.untyped) }
      def from_resp3(type, socket, &block); end
    end

    mixes_in_class_methods ClassMethods
  end
end
