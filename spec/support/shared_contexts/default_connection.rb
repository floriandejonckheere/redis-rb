# frozen_string_literal: true

# rubocop:disable RSpec/ContextWording
RSpec.shared_context "default connection" do
  let(:io) { StringIO.new }
  let(:default_options) { {} }
  let(:default_database) { Rediss::Database.new(0) }

  let(:default_connection) { Rediss::Connection.new(io, default_options, default_database) }
end
# rubocop:enable RSpec/ContextWording
