# frozen_string_literal: true
# typed: true

module Redis
  module Type
    extend T::Sig
    extend T::Helpers

    interface!

    sig { abstract.returns(String) }
    def to_resp3; end

    module ClassMethods
      extend T::Sig
      extend T::Helpers

      interface!

      sig { abstract.params(type: String, socket: Redis::Socket, block: T.proc.returns(Redis::Type)).returns(T.attached_class) }
      def from_resp3(type, socket, &block); end
    end

    mixes_in_class_methods ClassMethods
  end
end
