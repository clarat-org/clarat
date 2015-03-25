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

    transform_hits_to_offers
  end

  ### For Kaminari ##

  alias_method :total_pages, :nbPages
  alias_method :current_page, :page

  def limit_value
    PER_PAGE
  end

  private

  OFFER_FIELDS = %w(
    id name description next_steps encounter slug location_id created_at
    updated_at fax opening_specification comment completed approved
    approved_at legal_information created_by approved_by renewed expires_at
  ) # organization_names encounter_value objectID _highlightResult _tags

  def transform_hits_to_offers
    @hits = @hits.map do |json|
      offer = Offer.new json.slice(*OFFER_FIELDS)

      json['organization_names'].split(', ').each do |n|
        offer.organizations << Organization.new(name: n)
      end

      unless json['_geoloc'].blank?
        offer.location = Location.new(
          street: json['location_street'], city: json['location_city'],
          zip: json['location_zip'] # _geoloc
        )
      end

      offer
    end
  end
end
