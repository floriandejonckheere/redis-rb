# frozen_string_literal: true

module Rediss
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    PRE   = nil

    VERSION = [MAJOR, MINOR, PATCH].compact.join(".")

    STRING = [VERSION, PRE].compact.join("-")
  end

  VERSION = Rediss::Version::STRING

  # Protocol version (RESP3)
  PROTOCOL = 3
end
