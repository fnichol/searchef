# Searchef

Stub your Chef searches with pre-canned responses. Good for use when unit
testing or dummying out a Chef run that uses search calls.

## Installation

Add this line to your application's Gemfile:

    gem 'searchef'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install searchef

## Usage

Require the library and include the `Searchef::API` module for convenience:

```ruby
require 'searchef'

include Searchef::API
```

```ruby
# stub search for all nodes with the `web_node` role in their run list
stub_search(:node, "roles:web_node").to_return([
  node_stub("web1.example.com"),
  node_stub("web2.example.com")
])

require 'chef/search/query'

# if running in pry, let's set a node name for signing requests
Chef::Config[:node_name] = "durr"

# run the search
query = Chef::Search::Query.new
query.search(:node, "roles:web_node")

# => [[node[web1.example.com], node[web2.example.com]], 0, 2]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
