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

require 'chef/platform'
require 'chef/node'
require 'fauxhai'

module Searchef

  # Class to help generate Chef::Node objects.
  #
  # @author Fletcher Nichol <fnichol@nichol.ca>
  #
  class NodeStubCreator

    # Constructs a creator object which will return a Chef::Node object when
    # sent the #create message.
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
    #
    def initialize(name, options = {}, &block)
      @name       = name
      @attrs      = options[:attrs] || Hash.new
      @ohai       = options[:ohai] || Hash.new
      @platform   = options[:platform] || "ubuntu"
      @version    = options[:version] || "12.04"
      @node_block = block if block_given?
    end

    # Creates and returns a Chef::Node object.
    #
    # @return [Chef::Node] a Chef node object
    #
    def create
      node = Chef::Node.new
      node.name(name)
      node.consume_external_attrs(ohai_data, attr_data)
      node.instance_eval(&node_block) unless node_block.nil?
      node
    end

    private

    attr_reader :name, :attrs, :ohai, :platform, :version, :node_block

    def ohai_data
      fauxhai = Fauxhai.mock(:platform => platform, :version => version).data
      Mash.new(fauxhai.merge(ohai))
    end

    def attr_data
      Mash.new(attrs)
    end
  end
end
