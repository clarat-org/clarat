class SearchManager
  attr_reader :search_form, :page

  delegate :query, :category, :geolocation, to: :search_form, prefix: false

  def initialize(search_form, page: nil)
    @search_form = search_form
    @page = [(page || 0) - 1, 0].max # essentially "-1", normalize for algolia
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

  def hits
    @hits ||= Algolia.multiple_queries(queries).fetch('results')
  end

  def queries
    @queries ||= [personal_query, remote_query, nearby_query, facet_query]
                 .compact
                 .map(&:query_hash)
  end

  def personal_query
    if personal?
      PersonalQuery.new(personal_query_attrs)
    end
  end

  def remote_query
    RemoteQuery.new(remote_query_attrs)
  end

  def nearby_query
    NearbyQuery.new(geolocation: geolocation)
  end

  def facet_query
    FacetQuery.new(facet_query_attrs)
  end

  # This is where the translation between the domain model and
  # the algolia model starts. this could be extracted to one/several
  # translation object(s)

  def personal_query_attrs
    {
      query: query,
      category: category,
      geolocation: geolocation,
      search_radius: search_radius
    }
  end

  def remote_query_attrs
    {
      query: query,
      category: category,
      geolocation: geolocation,
      teaser: personal?
    }
  end

  def facet_query_attrs
    {
      query: query,
      category: category,
      geolocation: geolocation,
      search_radius: search_radius
    }
  end

  def personal?
    search_form.contact_type == :personal
  end

  # TODO: this needs to be properly unit tested
  def filters
    @filters ||= %w(age audience language).map do |type|
      search_form.send("#{type}_filter")
    end.compact
  end

  # wide radius or use exact location
  def search_radius
    if search_form.exact_location
      100
    else
      50_000
    end
  end
end
