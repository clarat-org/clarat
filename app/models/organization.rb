# Monkeypatch clarat_base Organization
require ClaratBase::Engine.root.join('app', 'models', 'organization')

class Organization < ActiveRecord::Base
  # Frontend-only Methods

  def canonical_section
    sections.pluck(:identifier).first || Section::DEFAULT
  end

  # structured information to build a gmap marker for this orga
  def gmaps_info
    {
      title: name,
      address: location.address
    }
  end
end
