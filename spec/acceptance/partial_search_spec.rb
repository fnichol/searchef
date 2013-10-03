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

require_relative '../spec_helper'

require_relative '../../vendor/partial_search/libraries/partial_search'

require 'searchef'

describe "Node Search" do
  include Searchef::API

  before do
    @saved_state = Hash.new
    [:node_name, :client_key, :search_url, :chef_server_url].each do |key|
      @saved_state[key] = Chef::Config[key]
    end

    Chef::Config[:node_name] = "acceptance"
    Chef::Config[:client_key] = nil
    Chef::Config[:search_url] = Chef::Config[:chef_server_url] = "http://fakeserver:666"
  end

  after do
    [:node_name, :client_key, :search_url, :chef_server_url].each do |key|
      Chef::Config[key] = @saved_state.delete(key)
    end

    clear_stub_searches!
  end

  describe "greedy search stub" do
    before do
      stub_partial_search(:node).to_return([
        { "ip" => '10.1.2.3' },
        { "ip" => '192.168.9.10' }
      ])
    end

=begin
    it "matches with no additonal search parameters" do
    end
=end

    it "matches with arbitrary search parameters" do
      nodes = partial_search(:node, "query", :keys => {"ip" => %w{ohai ipaddress}})
      assert_equal [{ "ip" => '10.1.2.3' }, { "ip" => '192.168.9.10' }], nodes
    end
  end

=begin
  describe "strict search stub" do

    before do
      stub_search(:node, "roles:mysql", "ASC", 2, 99).to_return([
        node_stub("one", :ohai => { :ipaddress => '10.1.2.3' }),
        node_stub("two", :ohai => { :ipaddress => '192.168.9.10' })
      ])
    end

    it "matches a fully qualified search" do
      nodes, start, total = query.search(:node, "roles:mysql", "ASC", 2, 99)

      start.must_equal 0
      total.must_equal 2
      nodes.first.ipaddress.must_equal '10.1.2.3'
      nodes.last.ipaddress.must_equal '192.168.9.10'
    end

    it "does not match with a different query parameter" do
      proc { query.search(:node, "*:*", "ASC", 2, 99) }.must_raise SocketError
    end
  end

  describe "overlapping search stubs" do

    before do
      stub_search(:node).to_return([
        node_stub("allthethings")
      ])

      stub_search(:node, "platform:ubuntu", "eh", 6, 10).to_return([
        node_stub("uby")
      ])
    end

    it "performing the narrower search match returns uby" do
      nodes, start, total = query.search(:node, "platform:ubuntu", "eh", 6, 10)

      start.must_equal 0
      total.must_equal 1
      nodes.first.name.must_equal 'uby'
    end

    it "performing a fuzzier search returns allthethings" do
      nodes, start, total = query.search(:node, "recipes:*", "eh")

      start.must_equal 0
      total.must_equal 1
      nodes.first.name.must_equal 'allthethings'
    end
  end
=end
end
