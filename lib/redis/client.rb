# frozen_string_literal: true

module Redis
  class Client
    attr_reader :socket

    def initialize(socket)
      @socket = socket
    end

    def start
      info "Client #{address} connected"
    end

    private

    def address
      "#{socket.peeraddr[3]}:#{socket.peeraddr[1]}"
    end
  end
end
