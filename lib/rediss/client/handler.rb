# frozen_string_literal: true
# typed: true

require "reline"

module Rediss
  class Client
    class Handler
      extend T::Sig

      sig { returns(Connection) }
      attr_reader :connection

      sig { params(connection: Connection).void }
      def initialize(connection)
        @connection = connection
      end

      sig { void }
      def start
        info "Connecting to #{connection.address}"

        loop do
          # Read user input
          request = Reline
            .readline("#{connection.address}> ", true)

          break unless request

          # Split up request into command and arguments
          request = request
            .split

          debug "Write #{request.to_resp3.inspect}"

          # Send command to server
          connection.write(request.to_resp3)

          # Read server response
          type = TypeParser
            .new(connection)
            .read

          debug "Read #{type.to_resp3.inspect}"

          break unless type

          puts type.to_pretty_s
        end
      end
    end
  end
end
