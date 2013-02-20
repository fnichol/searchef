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

require 'searchef/node_stub_creator'

describe Searchef::NodeStubCreator do

  let(:node_name) { "nodey.mcnode.local" }
  let(:opts)      { Hash.new }
  let(:node)      { Searchef::NodeStubCreator.new(node_name, opts).create }

  it "sets the node's name" do
    node.name.must_equal "nodey.mcnode.local"
  end

  it "contains default ohai data from fauxhai" do
    node[:etc][:passwd].keys.must_include "fauxhai"
  end

  it "overrides ohai data with an :ohai hash in options" do
    opts[:ohai] = { :ipaddress => '127.127.127.127' }

    node[:ipaddress].must_equal "127.127.127.127"
  end

  it "overrides attribute data with an :attrs hash in options" do
    opts[:attrs] = { :a => { :b => 'c' } }

    node[:a][:b].must_equal "c"
  end

  it "defaults platform to ubuntu" do
    node[:platform].must_equal "ubuntu"
  end

  it "defaults platform version to 12.04" do
    node[:platform_version].must_equal "12.04"
  end

  it "overrides node platform and version in options" do
    opts[:platform] = 'centos'
    opts[:version]  = '6.3'

    node['platform'].must_equal "centos"
    node['platform_version'].must_equal "6.3"
  end

  it "accepts a block to override attribute data" do
    node_stub = Searchef::NodeStubCreator.new(node_name, opts) do
      default['led']['zeppelin'] = 'achilles'
    end
    node = node_stub.create

    node.led.zeppelin.must_equal 'achilles'
  end
end
