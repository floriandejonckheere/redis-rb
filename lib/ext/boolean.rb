# frozen_string_literal: true
# typed: true

require "rediss/type"

module Boolean
  include Rediss::Type

  extend ActiveSupport::Concern
  extend T::Sig

  included do
    extend T::Sig

    sig { override.returns(String) }
    def to_resp3
      "##{self == true ? 't' : 'f'}\r\n"
    end

    sig { override.params(indent: Integer).returns(String) }
    def to_pretty_s(indent: 0)
      self ? "true" : "false"
    end

    sig { override.params(type: String, connection: Rediss::Connection, block: T.proc.returns(Rediss::Type)).returns(T.attached_class) }
    def self.from_resp3(type, connection, &block)
      # Read value
      value = connection
        .gets
        .chomp

      value == "t"
    end
  end
end
