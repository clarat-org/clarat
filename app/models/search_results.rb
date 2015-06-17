# Non-Active Record Object to work with algolias return json
class SearchResults
  PER_PAGE = 20
  KEYS = %w(hits nbHits page nbPages hitsPerPage query params index facets)
  attr_accessor(*KEYS.map(&:to_sym))

  # By default methods hit the result set array
  extend Forwardable
  def_delegators :@hits, :each, :any?, :empty?, :first, :[]

  def initialize json
    KEYS.each do |key|
      self.send "#{key}=", json[key]
    end

    transform_hits_to_offers
  end

  ### For Kaminari ##

  alias_method :total_pages, :nbPages

  def current_page
    page + 1 # Algolia is zero-based, Kaminari isn't
  end

  def limit_value
    PER_PAGE
  end

  private

  def transform_hits_to_offers
    @hits = @hits.map do |json|
      offer = new_offer_from_json_slice json
      offer = fill_offer_with_organizations(offer, json['organization_names'])
      fill_in_location(offer, json)
    end
  end

  def new_offer_from_json_slice json
    Offer.new json.slice(*%w(
      id name description next_steps encounter slug location_id created_at
      updated_at opening_specification comment completed approved approved_at
      legal_information created_by approved_by renewed expires_at encounter
    )) # organization_names encounter_value objectID _highlightResult _tags
  end

  def fill_offer_with_organizations offer, organization_names
    organization_names.split(', ').each do |n|
      offer.organizations << Organization.new(name: n)
    end
    offer
  end

  def fill_in_location offer, json
    unless json['_geoloc'].blank?
      offer.location = Location.new(
        street: json['location_street'], city: json['location_city'],
        zip: json['location_zip'],
        latitude: json['_geoloc']['lat'],
        longitude: json['_geoloc']['lng']
      )
    end
    offer
  end
end
