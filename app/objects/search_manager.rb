class SearchManager
  attr_reader :search_form, :page

  def initialize(search_form, page: nil)
    @search_form = search_form
    @page = [(page || 0) - 1, 0].max
  end

  def queries
    @queries ||= (if search_form.contact_type == 'personal'
                   [
                     PersonalQuery.new({
                       query: search_form.query,
                       category: search_form.category,
                       geolocation: search_form.geolocation,
                     }),
                     RemoteQuery.new({
                       query: search_form.query,
                       category: search_form.category,
                       geolocation: search_form.geolocation,
                       teaser: true
                     })
                   ]
    else
      [
         RemoteQuery.new({
           query: search_form.query,
           category: search_form.category,
           geolocation: search_form.geolocation
         })
      ]
    end + [NearbyQuery.new({ geolocation: search_form.geolocation }),
           FacetQuery.new({
                       query: search_form.query,
                       category: search_form.category,
                       geolocation: search_form.geolocation,
                     })])
      .map(&:query_hash)
  end

  def hits
    @hits ||= Algolia.multiple_queries(queries).fetch('results')
  end

  def personal_hits
    @personal ||= if search_form.contact_type == 'personal'
                    SearchResults.new hits[0]
                  end
  end

  def remote_hits
    @personal ||= SearchResults.new hits[-3]
  end

  def nearby_hits
    @personal ||= SearchResults.new hits[-2]
  end

  def facets_hits
    @personal ||= SearchResults.new hits[-1]
  end
end
