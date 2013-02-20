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

require_relative '../../spec_helper'

require 'searchef/search_stub'

describe Searchef::SearchStub do

  let(:request)     { mock('RequestStub') }

  it "sets up a stub_request" do
    WebMock::RequestStub.expects(:new).with { |method, uri_regex|
      method == :get &&
      uri_regex.source.gsub(/\\/, '') =~ %r{http://localhost:4000/search/node}
    }.returns(request)

    request.expects(:with).with(
      :query => {}
    ).returns(request)

    request.expects(:to_return).with(
      :headers => { 'Content-Type' => 'application/json; charset=utf-8' },
      :body => { 'rows' => [{ 'a' => 'b'}], 'total' => 1, 'start' => 0 }.to_json
    ).returns(request)

    Searchef::SearchStub.new(:node, nil, nil, nil, nil).to_return([
      { 'a' => 'b' }
    ])
  end

  it "setup up a stub_request with query, sort, start, and rows if set" do
    type = :role
    query = "bacon"
    sort = "backwards"
    start = 42
    rows = 43

    WebMock::RequestStub.expects(:new).with { |method, uri_regex|
      uri_regex.source.gsub(/\\/, '') =~ %r{http://localhost:4000/search/role}
    }.returns(request)

    request.expects(:with).with(:query => {
      'q' => 'bacon', 'sort' => 'backwards', 'rows' => '43', 'start' => '42'
    }).returns(request)

    request.expects(:to_return).returns(request)

    Searchef::SearchStub.new(type, query, sort, start, rows).to_return([])
  end
end
