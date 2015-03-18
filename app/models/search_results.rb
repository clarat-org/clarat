# Non-Active Record Object to work with algolias return json
class SearchResults
  PER_PAGE = 20
  KEYS = %w(hits nbHits page nbPages hitsPerPage query params index facets)
  attr_accessor(*KEYS.map(&:to_sym))

  # By default methods hit the result set array
  extend Forwardable
  def_delegators :@hits, :each, :any?, :first, :[]

  def initialize json
    KEYS.each do |key|
      self.send "#{key}=", json[key]
    end

    @hits = @hits.map do |hit|
      offer = Offer.new hit.slice(*%w(
        id name description next_steps encounter slug location_id created_at
        updated_at fax opening_specification comment completed approved
        approved_at legal_information created_by approved_by renewed expires_at
      ))
      hit['organization_names'].split(', ').each do |n|
        offer.organizations << Organization.new(name: n)
      end
      unless hit['_geoloc'].blank?
        offer.location = Location.new(
          street: hit['location_street'], city: hit['location_city'],
          zip: hit['location_zip'] # _geoloc
        )
      end
      # organization_names encounter_value objectID _highlightResult _tags
      offer
    end
  end

  ### For Kaminari ##

  def total_pages
    @nbPages
  end

  def current_page
    @page
  end

  def limit_value
    PER_PAGE
  end
end
