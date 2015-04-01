class SearchManager
  attr_reader :search_form, :page

  def initialize(search_form, page: nil)
    @search_form = search_form
    @page = [(page || 0) - 1, 0].max
  end

  # TODO: rewrite hits[] to not be dependent on array ordering
  def personal_hits
    @personal ||= if search_form.contact_type == :personal
                    SearchResults.new hits[0]
                  end
  end

  # TODO: rewrite hits[] to not be dependent on array ordering
  def remote_hits
    @remote ||= SearchResults.new hits[-3]
  end

  # TODO: rewrite hits[] to not be dependent on array ordering
  def nearby_hits
    @nearby ||= SearchResults.new hits[-2]
  end

  # TODO: rewrite hits[] to not be dependent on array ordering
  def facets_hits
    @facets ||= SearchResults.new(hits[-1]).facets['_tags'] || {}
  end

  private

  def personal_query_attrs
    {
      query: search_form.query,
      category: search_form.category,
      geolocation: search_form.geolocation
    }
  end

  def personal_query
    if personal?
      PersonalQuery.new(personal_query_attrs)
    end
  end

  def personal?
    search_form.contact_type == :personal
  end

  def remote_query_attrs
    {
      query: search_form.query,
      category: search_form.category,
      geolocation: search_form.geolocation,
      teaser: personal?
    }
  end

  def remote_query
    RemoteQuery.new(remote_query_attrs)
  end

  def nearby_query
    NearbyQuery.new(geolocation: search_form.geolocation)
  end

  def facet_query_attrs
    {
      query: search_form.query,
      category: search_form.category,
      geolocation: search_form.geolocation
    }
  end

  def facet_query
    FacetQuery.new(facet_query_attrs)
  end

  def queries
    @queries ||= [personal_query, remote_query, nearby_query, facet_query]
                 .compact
                 .map(&:query_hash)
  end

  def hits
    @hits ||= Algolia.multiple_queries(queries).fetch('results')
  end

  # exact_location ? 100 : 50_000
  # unless @filters
  # @filters = []
  # %w(age audience language).each do |type|
  # requested_filter = send("#{type}_filter")
  # mental note to self:
  # send over { age: 'boy' }
end
