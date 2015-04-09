class RemoteQuery < BaseQuery
  attr_reader :geolocation, :teaser

  # TODO: geolocation
  def initialize(geolocation:, teaser: false, **args)
    super(args)
    @geolocation = geolocation
    @teaser = teaser
  end

  def query_hash
    super.merge(
      index_name: Offer.remote_index_name,
      numericFilters: area_filter
    ).merge(page_options)
  end

  def page_options
    if teaser
      { page: 0, hitsPerPage: 2 }
    else
      {}
    end
  end

  # Remote search is in a separate index and uses the area as a bounding box,
  # in a general search context this only gets 2 results as a teaser
  def area_filter
    lat, long = [geolocation.latitude, geolocation.longitude]
    "area_minlat<=#{lat},area_maxlat>=#{lat},area_minlong<=#{long},"\
    "area_maxlong>=#{long}"
  end
end
