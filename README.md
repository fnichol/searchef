# Searchef

[![Build Status](https://travis-ci.org/fnichol/searchef.png?branch=master)](https://travis-ci.org/fnichol/searchef)
[![Code Climate](https://codeclimate.com/github/fnichol/searchef.png)](https://codeclimate.com/github/fnichol/searchef)

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

### Setup

Require the library and include the `Searchef::API` module for convenience:

```ruby
require 'searchef'

include Searchef::API
```

### Stubbing Node Searches

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

You can also stub more complicated nodes with specific data:

```ruby
# setting a node platform and platform verson
node_stub("node1.example.com", :platform => "centos", :version => "6.3")

# overriding default fauxhai ohai data
node_stub("node2.example.com", :ohai => { :ipaddress => "19.2.168.10.1" })

# set node attribute data, such as the run_list
node_stub("node2.example.com", :attrs => {
  :run_list => [ 'recipe[common::base]', 'role[load_balancer]' ]
})

# using a block which provides access to the attributes file dsl methods
node_stub("node3.example.com", :ohai => { :ipaddress => "10.10.12.27" }) do
  default['mysql']['tunable']['tmp_table_size'] = "64M"
end
```

### Stubbing Data Bag Searches

Data bags are a hash of data, so you can return data bag items as an array of
hashes:

```ruby
stub_search(:users, 'groups:admin').to_return([
  {
    "id" => "adam",
    "comment" => "Adam Administrator",
    "groups" => [
      "admin"
    ],
    "ssh_keys" => [],
    "shell" => "/bin/bash"
  }
])
```

If your `data_bag_path` is setup, you could also fectch the data from a real
data bag, using the `data_bag_item` method:

```ruby
stub_search(:users, 'groups:admin').to_return([
  data_bag_item("users", "adam")
])
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
