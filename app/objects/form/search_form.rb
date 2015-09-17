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

  # Hidden Filters (controls get rendered in JS)
  attribute :contact_type, String, default: :personal
  attribute :age, String
  attribute :target_audience, String
  attribute :exclusive_gender, String
  attribute :language, String
  attribute :encounter, String

  # Methods #

  def initialize *attrs
    super

    if search_location && search_location != I18n.t('conf.current_location')
      self.generated_geolocation = search_location_instance.geoloc
    end
  end

  private

  def search_location_instance
    @_search_location_instance ||=
      SearchLocation.find_or_generate(search_location)
  end
end
