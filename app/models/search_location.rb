# Monkeypatch clarat_base SearchLocation
require ClaratBase::Engine.root.join('app', 'models', 'search_location')

class SearchLocation < ActiveRecord::Base
  # Frontend-only Methods

  def self.find_or_generate location_string
    location_string ||= I18n.t('conf.default_location')
    find_by_query(normalize(location_string)) || create!(query: location_string)
  rescue ActiveRecord::RecordInvalid
    raise InvalidLocationError
  end
end
