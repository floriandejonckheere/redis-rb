# frozen_string_literal: true
# typed: true

module Redis
  extend T::Sig

  Type = T.type_alias { T.any(String, Error, Integer, Array, Hash) }
end
