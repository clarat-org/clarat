require 'algolia/webmock' # general mocks
q_response = <<-RESPONSE
{
"hits" : [],
"nbHits" : 0,
"page" : 0,
"nbPages" : 0,
"hitsPerPage" : 10,
"processingTimeMS" : 1,
"facets" : {
},
"query" : "",
"params" : "query="
}
RESPONSE
WebMock.stub_request(:get, /.*\.algolia\.io\/1\/indexes\/[^\/]+/).to_return(
  body: q_response
)
