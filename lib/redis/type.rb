# frozen_string_literal: true
# typed: true

module Redis
  extend T::Sig

  SimpleType = T.type_alias { T.any(String, Error, Integer, NilClass) }
  AggregateType = T.type_alias { T.any(Array, Hash) }

  Type = T.type_alias { T.any(SimpleType, AggregateType) }
end
