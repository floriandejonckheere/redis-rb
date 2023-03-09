# Rediss

![Continuous Integration](https://github.com/floriandejonckheere/redis-rb/workflows/Continuous%20Integration/badge.svg)
![Release](https://img.shields.io/github/v/release/floriandejonckheere/redis-rb?label=Latest%20release)

Unofficial RESP3-compliant Redis server implementation written in pure Ruby.

## Installation

Clone the repository and install the dependencies:

```sh
git clone git@github.com:floriandejonckheere/redis-rb.git
cd redis-rb
gem install bundler
bundle install
```

## Usage

### Server

Execute `bin/rediss-server --help` to see all available commands and their arguments.

### Client

Execute `bin/rediss-client --help` to see all available commands and their arguments.

## Commands

Currently, the following commands are supported:

**Connection**:
- `HELLO`
- `PING`
- `SELECT`

## Release

Update the changelog and bump the version in `lib/rediss/version.rb`.
Create a git tag for the version and push it to Github.
A Ruby gem will automatically be built and pushed to the [RubyGems](https://www.rubygems.org/).

```sh
nano lib/rediss/version.rb
git add lib/rediss/version.rb
git commit -m "Bump version to v1.0.0"
git tag v1.0.0
git push origin master
git push origin v1.0.0
```

## Contributing

1. Fork the repository (<https://github.com/floriandejonckheere/redis-rb/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

See [LICENSE.md](LICENSE.md).
