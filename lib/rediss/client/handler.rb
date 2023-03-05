# frozen_string_literal: true
# typed: true

module Rediss
  class Client
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
        info "Connecting to #{address}"

        loop do
          # Read user input
          request = Reline
            .readline("#{address}> ", true)

          break unless request

          # Split up request into command and arguments
          request = request
            .split

          debug "Write #{request.to_resp3.inspect}"

          # Send command to server
          socket.write(request.to_resp3)

          # Read server response
          type = TypeParser
            .new(socket)
            .read

          debug "Read #{type.to_resp3.inspect}"

          break unless type

          puts type.to_pretty_s
        end
      end

      private

      sig { returns(String) }
      def address
        @address ||= "#{socket.peeraddr[3]}:#{socket.peeraddr[1]}"
      end
    end
  end
end
