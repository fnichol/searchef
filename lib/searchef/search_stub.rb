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
require 'uri'

module Searchef

  class SearchStub

    include WebMock::API

    def initialize(type, query, sort, start, rows)
      @type = type
      @params = Hash.new
      @params["q"]      = query       if query
      @params["sort"]   = sort        if sort
      @params["start"]  = start.to_s  if start
      @params["rows"]   = rows.to_s   if rows
    end

    def to_return(objects)
      stub_request(:get, %r{/search/#{type}}).
        with(:query => hash_including(params)).
        to_return(:headers => response_headers, :body => response_body(objects))
    end

    private

    attr_reader :type, :params

    def escape(string)
      string && URI.escape(string.to_s)
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
