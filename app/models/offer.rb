# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'offer')

class Offer < ActiveRecord::Base
  # Methods

  def canonical_section
    section_filters.pluck(:identifier).first
  end

  def in_section? section
    section_filters.where(identifier: section).count > 0
  end
end
