# frozen_string_literal: true

require "console"

class Object
  delegate :debug, :info, :warn, :error, :fatal, to: :logger

  def logger
    Console.logger
  end
end
