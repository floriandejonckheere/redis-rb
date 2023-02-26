# frozen_string_literal: true

require_relative "lib/rediss/version"

Gem::Specification.new do |spec|
  spec.name          = "rediss"
  spec.version       = Rediss::VERSION
  spec.authors       = ["Florian Dejonckheere"]
  spec.email         = ["florian@floriandejonckheere.be"]

  spec.summary       = "Unofficial RESP3-compliant Redis server"
  spec.description   = "Unofficial RESP3-compliant Redis server implementation written in pure Ruby"
  spec.homepage      = "http://github.com/floriandejonckheere/redis-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.0")

  spec.metadata["source_code_uri"] = "https://github.com/floriandejonckheere/redis-rb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|docs|bin|.github|.rspec|.rubocop.yml)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["rediss-server"]
  spec.require_paths = ["lib"]

  spec.metadata = {
    "rubygems_mfa_required" => "true",
  }

  spec.add_runtime_dependency "activesupport", ">= 6.0", "< 7.1"
  spec.add_runtime_dependency "async", "~> 2.3"
  spec.add_runtime_dependency "sorbet-runtime", "~> 0.5"
  spec.add_runtime_dependency "zeitwerk", "~> 2.4"
end
