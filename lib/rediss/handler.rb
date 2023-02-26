# frozen_string_literal: true
# typed: true

module Rediss
  class Handler
    extend T::Sig

    sig { returns(Socket) }
    attr_reader :socket

    sig { params(socket: Socket).void }
    def initialize(socket)
      @socket = socket
    end

    sig { void }
    def start
      info "Client #{address} connected"

      loop do
        # Read user input
        type = TypeParser
          .new(socket)
          .read

        break unless type

        # Parse command
        command = CommandParser
          .new(type)
          .read

        # Validate and execute command
        result = command
          .tap(&:validate)
          .execute

        socket.write(result.to_resp3)
      rescue ArgumentError => e
        socket.write(Error.new("ERR", e.message).to_resp3)
      end
    ensure
      info "Client #{address} disconnected"
    end

    private

    sig { returns(String) }
    def address
      @address ||= "#{socket.peeraddr[3]}:#{socket.peeraddr[1]}"
    end
  end
end
