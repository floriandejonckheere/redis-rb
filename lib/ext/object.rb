# frozen_string_literal: true

class Object
  delegate :debug, :info, :warn, :error, :fatal, to: :logger

  def logger
    Redis.logger
  end
end