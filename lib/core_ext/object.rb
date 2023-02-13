# frozen_string_literal: true

module CoreExt
  module Object
    delegate :debug, :info, :warn, :error, :fatal, to: :logger

    def logger
      Redis.logger
    end
  end
end

Object.include CoreExt::Object
