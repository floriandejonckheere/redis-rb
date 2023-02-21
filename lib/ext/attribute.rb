# frozen_string_literal: true
# typed: true

class Attribute < Hash
  extend T::Sig

  sig { returns(String) }
  def to_resp3
    "|#{count * 2}\r\n#{flat_map { |k, v| [k.to_resp3, v.to_resp3] }.join}"
  end
end
