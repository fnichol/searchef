require_relative '../../spec_helper'

require 'searchef/partial_search_stub'

describe Searchef::PartialSearchStub do
  def search_regex(type)
    %r{https?://localhost:(4000|443)/search/#{type}}
  end

  let(:request) { mock('RequestStub') }

  it "sets up a stub_request" do
    WebMock::RequestStub.expects(:new).with { |method, uri_regex|
      method == :any &&
      uri_regex.source.gsub(/\\/, '') =~ search_regex("node")
    }.returns(request)

    request.expects(:with).with(
      :query => {}
    ).returns(request)

    request.expects(:to_return).with(
      :headers => { 'Content-Type' => 'application/json; charset=utf-8' },
      :body => {
        'rows' => [{ 'data' => { 'a' => 'b'} }],
        'total' => 1, 'start' => 0
      }.to_json
    ).returns(request)

    Searchef::PartialSearchStub.new(:node, nil, nil, nil, nil).to_return([
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
      uri_regex.source.gsub(/\\/, '') =~ search_regex("role")
    }.returns(request)

    request.expects(:with).with(:query => {
      'q' => 'bacon', 'sort' => 'backwards', 'rows' => '43', 'start' => '42'
    }).returns(request)

    request.expects(:to_return).returns(request)

    Searchef::PartialSearchStub.new(type, query, sort, start, rows).
      to_return([])
  end
end
