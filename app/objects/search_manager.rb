class SearchManager
  attr_reader :search_form, :page

  def initialize(search_form, page: nil)
    @search_form = search_form
    @page = [(page || 0) - 1, 0].max
  end

  def queries
    @queries ||= (if search_form.contact_type == :personal
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
    @personal ||= if search_form.contact_type == :personal
                    SearchResults.new hits[0]
                  end
  end

  def remote_hits
    @remote ||= SearchResults.new hits[-3]
  end

  def nearby_hits
    @nearby ||= SearchResults.new hits[-2]
  end

  def facets_hits
    @facets ||= SearchResults.new(hits[-1]).facets['_tags'] || {}
  end

        #exact_location ? 100 : 50_000
  #
        #unless @filters
          #@filters = []
          #%w(age audience language).each do |type|
            #requested_filter = send("#{type}_filter")
            # mental note to self:
            # send over { age: 'boy' }
end
