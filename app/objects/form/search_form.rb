# Form object to render form elements and links. Rest is handled in JS.
class SearchForm
  # Turn into quasi ActiveModel #
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  # Extensions #
  extend Enumerize

  # Attributes (since this is not ActiveRecord) #

  attr_accessor :hits, :personal_hits, :remote_hits, :national_hits

  attribute :query, String
  attribute :search_location, String
  attribute :generated_geolocation, String
  attribute :category, String

  ## Hidden Options

  # exact_location: Map had multiple markers on the same location and now the
  # search focusses only on that specific point.
  attribute :exact_location, Boolean, default: false

  # Filters

  CONTACT_TYPES = [:personal, :remote]
  attribute :contact_type, String, default: :personal
  enumerize :contact_type, in: CONTACT_TYPES
  ### Age
  attribute :age, String
  enumerize :age, in: Offer::MIN_AGE..Offer::MAX_AGE
  ### Language
  attribute :language, String
  enumerize :language, in: LanguageFilter::IDENTIFIER
  ### Audience
  attribute :target_audience, String
  ### Gender
  attribute :exclusive_gender, String
  ### Encounter
  attribute :encounters, String,
            default: (Offer::ENCOUNTERS - %w(personal)).join(',')
  ### Section (world)
  attribute :section, String, default: :family
  enumerize :section, in: SectionFilter::IDENTIFIER

  # Methods #

  def initialize cookies, *attrs
    super(*attrs)

    return if exact_location
    if search_location.blank? # Blank location => use cookies or default fallback
      load_geolocation_values!(cookies)
    elsif search_location && search_location != I18n.t('conf.current_location')
      self.generated_geolocation = search_location_instance.geoloc
    end
  end

  private

  def load_geolocation_values! cookies
    if cookies[:saved_search_location] && cookies[:saved_geolocation]
      self.search_location = cookies[:saved_search_location]
      self.generated_geolocation = cookies[:saved_geolocation]
    else
      self.search_location = I18n.t('conf.default_location')
      self.generated_geolocation = I18n.t('conf.default_latlng')
    end
  end

  def search_location_instance
    @_search_location_instance ||=
      SearchLocation.find_or_generate(search_location)
  end
end
