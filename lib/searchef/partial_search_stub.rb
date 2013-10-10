require 'searchef/search_stub'

module Searchef

  # A stubbed out Chef partial_search request and response. The test double is
  # introduced at the network layer.
  #
  class PartialSearchStub < SearchStub
    self.stub_method = :any

    protected

    def response_body(objects)
      objects = [objects] unless objects.is_a?(Array)
      super(objects.map { |obj| { "data" => obj } })
    end
  end
end
