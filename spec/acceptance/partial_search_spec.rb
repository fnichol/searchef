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

describe "Partial Search" do
  include Searchef::API

  before do
    @saved_state = Hash.new
    [:node_name, :client_key, :search_url, :chef_server_url].each do |key|
      @saved_state[key] = Chef::Config[key]
    end

    Chef::Config[:node_name] = "acceptance"
    Chef::Config[:client_key] = nil
    Chef::Config[:search_url] = "http://fakeserver:666"
    Chef::Config[:chef_server_url] = Chef::Config[:search_url]
  end

  after do
    [:node_name, :client_key, :search_url, :chef_server_url].each do |key|
      Chef::Config[key] = @saved_state.delete(key)
    end

    clear_stub_searches!
  end

  describe "partial search stub" do
    before do
      stub_partial_search(:node).to_return([
        { "ip" => '10.1.2.3' },
        { "ip" => '192.168.9.10' }
      ])
    end

    it "matches with no additonal search parameters" do
      nodes = partial_search(:node, "query")

      data = [
        { "data" => { "ip" => '10.1.2.3' } },
        { "data" => { "ip" => '192.168.9.10' } }
      ]
      assert_equal data, nodes
    end

    it "matches with arbitrary search parameters" do
      nodes = partial_search(:node, "query",
        :keys => {"ip" => %w{ohai ipaddress}})

      data = [
        { "ip" => '10.1.2.3' },
        { "ip" => '192.168.9.10' }
      ]
      assert_equal data, nodes
    end
  end
end
