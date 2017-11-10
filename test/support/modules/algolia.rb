# require 'algolia/webmock' # general mocks

module AlgoliaStubber
  EMPTY_RESPONSE = <<-RESPONSE
    {
      "hits" : [],
      "nbHits" : 0,
      "page" : 0,
      "nbPages" : 0,
      "hitsPerPage" : 10,
      "processingTimeMS" : 1,
      "facets" : {
        "_tags": {}
      },
      "query" : "",
      "params" : "query="
    }
  RESPONSE

  BATCH_RESPONSE = <<-RESPONSE
    {
      "results" :  [
        #{EMPTY_RESPONSE},
        #{EMPTY_RESPONSE},
        #{EMPTY_RESPONSE},
        #{EMPTY_RESPONSE}
      ]
    }
  RESPONSE

  def self.enable_empty_response
    WebMock.stub_request(:post, /.*\.algolia\.(io|net)\/1\/indexes\/[^\/]+\/queries/).to_return(
      body: BATCH_RESPONSE
    )
  end

  def self.filled_response_stub query, names, tags = {}
    offers = []
    names.each do |name|
      offers << Offer.find_by_name(name)
    end

    filled_response = {
      'hits' =>
        offers.map do |offer|
          offer.attributes.merge(
            'organization_names' => offer.organization_names,
            '_geoloc' => offer._geoloc
          )
        end,
      'nbHits' => offers.length,
      'page' => 0,
      'nbPages' => 1,
      'hitsPerPage' => 10,
      'processingTimeMS' => 1,
      'facets' => {
        '_tags' => tags
      },
      'query' => "#{query}",
      'params' => "query=#{query}"
    }
    batch_response = { 'results' => [filled_response, filled_response, filled_response, filled_response] }

    batch_response
  end
end

AlgoliaStubber.enable_empty_response

# stub <Offer instance>.index!
WebMock.stub_request(
  :put, /.*\.algolian?e?t?\.(io|net|com)\/1\/indexes\/[^\/]+\/[^\/]+/
).to_return(status: 200, body: "", headers: {})

WebMock.stub_request(
  :get, /.*\.algolian?e?t?\.(io|net|com)\/1\/indexes\/[^\/]+\/settings/
).to_return(status: 200, body: "", headers: {})

# {
# "hits" : [{
#   "id" : 311,
#   "name" : "Schulstation als Anlaufstelle für Schüler, Eltern und Lehrer",
#   "description" : "Die Schulstation ist eine vertrauensvolle Anlaufstelle für Schüler, Eltern und Lehrer an der Schule. In offenen Sprechstunden beraten und unterstützen die Mitarbeiter der Schulstation bei Krisen und in Belastungssituationen. Sie helfen beim Schlichten von Konflikten und vermitteln Dolmetscher. Außerdem finden die Jungen und Mädchen ein breites Freizeitangebot nach dem Unterricht.",
#   "next_steps" : "Melde dich unter 030 4147780 oder gehe zur offenen Sprechstunde an deiner Schule während der Öffnungszeiten. Die Elternberatung findet am Mittwoch und Freitag von 9:00 Uhr bis 12:00 Uhr statt.",
#   "telephone" : "0304147780",
#   "contact_name" : "Serdal Güler, Kamlasani Ponnampalam",
#   "email" : "schulstation-ch-gs@lebenswelt-berlin.de",
#   "encounter" : "fixed",
#   "frequent_changes" : false,
#   "slug" : "schulstation-als-anlaufstelle-fuer-schueler-eltern-und-lehrer-13435",
#   "location_id" : 183,
#   "created_at" : "2014-10-28T15:09:41.352+01:00",
#   "updated_at" : "2014-10-30T17:44:46.076+01:00",
#   "organization_id" : 64,
#   "fax" : "0304147781",
#   "opening_specification" : "",
#   "comment" : "",
#   "completed" : true,
#   "second_telephone" : "",
#   "approved" : true,
#   "approved_at" : "2014-10-30T17:44:46.076+01:00",
#   "_geoloc" : {
#     "lat" : 52.60169,
#     "lng" : 13.35807
#   },
#   "_tags" : ["Lernen", "Schulverweigerung", "Krisenintervention", "Migranten", "Mediation", "Konfliktlösung", "Lehrer", "Erziehungsberatung", "Schulsozialarbeit"],
#   "organization_name" : "Lebenswelt gGmbH",
#   "objectID" : "311",
#   "_highlightResult" : {
#     "name" : {
#       "value" : "Schulstation als Anlaufstelle für Schüler, Eltern und Lehrer",
#       "matchLevel" : "none",
#       "matchedWords" : []
#     },
#     "description" : {
#       "value" : "Die Schulstation ist eine vertrauensvolle Anlaufstelle für Schüler, Eltern und Lehrer an der Schule. In offenen Sprechstunden beraten und unterstützen die Mitarbeiter der Schulstation bei <em>Krisen</em> und in Belastungssituationen. Sie helfen beim Schlichten von Konflikten und vermitteln <em>Dolmetscher</em>. Außerdem finden die Jungen und Mädchen ein breites Freizeitangebot nach dem Unterricht.",
#       "matchLevel" : "full",
#       "matchedWords" : ["krise", "dolmetscher"]
#     }
#   },
#   "_rankingInfo" : {
#     "nbTypos" : 1,
#     "firstMatchedWord" : 1025,
#     "proximityDistance" : 8,
#     "userScore" : 156,
#     "geoDistance" : 0,
#     "geoPrecision" : 1,
#     "nbExactWords" : 1,
#     "words" : 2
#   }
# }],
# "nbHits" : 3,
# "page" : 0,
# "nbPages" : 1,
# "hitsPerPage" : 10,
# "processingTimeMS" : 1,
# "facets" : {
#   "_tags" : {
#     "Erziehungsberatung" : 3,
#     "Konfliktlösung" : 3,
#     "Krisenintervention" : 3,
#     "Lehrer" : 3,
#     "Lernen" : 3,
#     "Mediation" : 3,
#     "Migranten" : 3,
#     "Schulsozialarbeit" : 3,
#     "Schulverweigerung" : 3
#   }
# },
# "query" : "krise dolmetscher",
# "params" : "query=krise%20dolmetscher&getRankingInfo=1&facets=*&attributesToRetrieve=*&maxValuesPerFacet=10&hitsPerPage=10"
# }
