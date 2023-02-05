# frozen_string_literal: true
# typed: true

module Redis
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
        type = Types::Parser
          .new(socket)
          .read

        command = Commands::Parser
          .new(type)
          .read

        result = command
          .execute

        socket.write(result.to_s)
      rescue ArgumentError => e
        socket.write(Types::SimpleError.new(e.message).to_s)
      end
    end

    private

    sig { returns(String) }
    def address
      "#{socket.peeraddr[3]}:#{socket.peeraddr[1]}"
    end
  end
end
