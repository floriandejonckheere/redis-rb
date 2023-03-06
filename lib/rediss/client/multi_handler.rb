# frozen_string_literal: true
# typed: true

require "reline"

require "colorize"
require "super_diff"

module Rediss
  class Client
    class MultiHandler
      extend T::Sig

      sig { returns(T::Hash[String, Connection]) }
      attr_reader :connections

      sig { params(connections: T::Array[Connection]).void }
      def initialize(connections)
        @connections = connections.index_by(&:address)
      end

      sig { void }
      def start
        info "Connecting to #{connections.keys.join(', ')}"

        loop do
          # Read user input
          request = Reline
            .readline("redis> ", true)

          break unless request

          # Split up request into command and arguments
          request = request
            .split

          debug "Write #{request.to_resp3.inspect}"

          types = connections.filter_map do |address, connection|
            # Send command to server
            connection.write(request.to_resp3)

            # Read server response
            type = TypeParser
              .new(connection)
              .read

            debug "Read #{type.to_resp3.inspect} < #{address}"

            type
          end

          # Compare server responses
          if types.uniq.one?
            puts types.first.to_pretty_s
          else
            puts "Diff:".colorize(SuperDiff.configuration.header_color)
            puts "┌ (Key) ──────────────────────────────────┐".colorize(SuperDiff.configuration.border_color)
            puts "│ ".colorize(SuperDiff.configuration.border_color) +
                 "‹-› in expected.colorize(not in actual".colorize(SuperDiff.configuration.expected_color) +
                 "  │".colorize(SuperDiff.configuration.border_color)
            puts "│ ".colorize(SuperDiff.configuration.border_color) +
                 "‹+› in actual.colorize(not in expected".colorize(SuperDiff.configuration.actual_color) +
                 "  │".colorize(SuperDiff.configuration.border_color)
            puts "#{'│ '.colorize(SuperDiff.configuration.border_color)}‹ › in both expected and actual#{'         │'.colorize(SuperDiff.configuration.border_color)}"
            puts "└─────────────────────────────────────────┘".colorize(SuperDiff.configuration.border_color)

            diff = SuperDiff::Differs::Main
              .call(types[0], types[1], indent_level: 0)
              .presence

            puts diff if diff
          end
        end
      end
    end
  end
end
