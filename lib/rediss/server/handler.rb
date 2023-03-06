# frozen_string_literal: true
# typed: true

module Rediss
  class Server
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
        info "Client #{connection.address} connected"

        loop do
          # Read client request
          type = TypeParser
            .new(connection)
            .read

          debug "Read #{type.to_resp3.inspect}"

          break unless type

          # Parse command
          command = CommandParser
            .new(type, connection)
            .read

          # Validate and execute command
          result = command
            .tap(&:validate)
            .execute

          debug "Write #{result.to_resp3.inspect}"

          # Send response to client
          connection.write(result.to_resp3)
        rescue ArgumentError => e
          error = Error.new("ERR", e.message)

          debug "Write #{error.to_resp3.inspect}"

          connection.write(error.to_resp3)
        end
      ensure
        info "Client #{connection.address} disconnected"
      end
    end
  end
end
