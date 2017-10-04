# frozen_string_literal: true

# Monkeypatch clarat_base TargetAudienceFilter
require ClaratBase::Engine.root.join('app', 'models', 'filter')
require ClaratBase::Engine.root.join(
  'app', 'models', 'filters', 'target_audience_filter'
)

class TargetAudienceFilter < Filter
  # Frontend Methods

  # test this!
  # return identifiers for filtering (correct section and without generic)
  def self.identifiers_for_section section
    if section == 'family'
      FAMILY_IDENTIFIER.reject { |ident| ident == "#{section}_everyone" }
    else
      REFUGEES_IDENTIFIER.reject { |ident| ident == "#{section}_general" }
    end
  end
end
