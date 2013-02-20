# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2013, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'webmock'

module Searchef

  module API

    extend self

    # Stubs out a Chef search call at the network layer.
    #
    # @example Stub all searches in the node index to return an empty list
    #   stub_search(:node).to_return([])
    # @example Stub a search for nodes with a web_server role
    #   stub_search(:node, "roles:web_node").to_return([
    #     node_stub("web1.local"),
    #     node_stub("web2.local")
    #   ])
    # @example Stub a data bag search for users in the admin group
    #   stub_search(:users, 'groups:admin').to_return([
    #     {
    #       "id" => "adam",
    #       "comment" => "Adam Administrator",
    #       "groups" => [
    #         "admin"
    #       ],
    #       "ssh_keys" => [],
    #       "shell" => "/bin/bash"
    #     }
    #   ])
    # @example Stub a data bag search with actual data bag item content
    #   stub_search(:users, 'groups:admin').to_return([
    #     data_bag_item("users", "adam")
    #   ])
    #
    # @see Searchef::SearchStub
    # @see Searchef::SearchStub#to_return
    #
    # @param type [String,Symbol]
    # @param query [String]
    # @param sort [String]
    # @param start [String,Integer]
    # @param rows [String,Integer]
    #
    def stub_search(type, query=nil, sort=nil, start=nil, rows=nil, &block)
      SearchStub.new(type, query, sort, start, rows)
    end

    # Creates a new Chef::Node object suitable for using in a stubbed search
    # response.
    #
    # @example Setting a node's platform and version
    #   node_stub("node1.local", :platform => "centos", :version => "6.3")
    # @example Overriding default fauxhai data
    #   node_stub("node2.local", :ohai => { :ipaddress => "192.168.10.1" })
    # @example Setting attribute data such as the run_list
    #   node_stub("node3.local", :attrs => {
    #     :run_list => [ 'recipe[common::base]', 'role[load_balancer]' ]
    #   })
    # @example Using a block to set attribute data
    #   node_stub("node4.local", :ohai => { :ipaddress => "10.10.12.27" }) do
    #     default['mysql']['tunable']['tmp_table_size'] = "64M"
    #   end
    #
    # @see Searchef::NodeStubCreator
    #
    # @param name [String] the node name
    # @param options [Hash] options
    # @option options [Hash] :attrs (Hash.new) node attributes
    # @option options [Hash] :ohai (Hash.new) ohai attributes, overriding fake
    #   data provided by Fauxhai
    # @option options [Hash] :platform ("ubuntu") ohai platform name for the
    #   node
    # @option options [Hash] :version ("12.04") ohai platform version for the
    #   node
    # @return [Chef::Node] a Chef node object
    #
    def node_stub(name, options = {}, &block)
      NodeStubCreator.new(name, options, &block).create
    end

    # Clears all stubbed searches that have been defined.
    #
    def clear_stub_searches!
      WebMock.reset!
    end
  end
end
