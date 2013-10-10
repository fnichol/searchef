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

require 'chef/config'
require 'json'
require 'uri'
require 'webmock'

module Searchef

  # A stubbed out Chef search request and response. The test double is
  # introduced at the network layer.
  #
  # @author Fletcher Nichol <fnichol@nichol.ca>
  #
  class SearchStub

    include WebMock::API

    # Constructs a new stubbed search request. If the optional parameters such
    # as `query` and `sort` are not specified then any value for these
    # parameters will be matched. For example, if the `query` parameter is not
    # provided then the following search calls will be matched and stubbed:
    #
    # * search(:node)
    # * search(:node, "*:*")
    # * search(:node, "totallybogusentry")
    #
    def initialize(type, query, sort, start, rows)
      @type = type
      @params = Hash.new
      @params["q"]      = query       if query
      @params["sort"]   = sort        if sort
      @params["start"]  = start.to_s  if start
      @params["rows"]   = rows.to_s   if rows
    end

    def to_return(objects)
      stub_request(self.class.stub_method, %r{^#{base_url}/search/#{type}}).
        with(:query => hash_including(params)).
        to_return(:headers => response_headers, :body => response_body(objects))
    end

    protected

    attr_reader :type, :params

    class << self
      attr_accessor :stub_method
    end

    self.stub_method = :get

    def base_url
      Chef::Config[:search_url] || Chef::Config[:chef_server_url]
    end

    def response_headers
      { 'Content-Type' => 'application/json; charset=utf-8' }
    end

    def response_body(objects)
      # calling Arrray(objects) converts Chef::Node to an Array of attributes
      # which is not what we want
      objects = [objects] unless objects.is_a?(Array)

      response = Hash.new
      response["rows"] = objects
      response["total"] = response["rows"].length
      response["start"] = 0
      response.to_json
    end
  end
end
