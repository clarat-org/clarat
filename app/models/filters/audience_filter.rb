class AudienceFilter < Filter
  extend Enumerize

  IDENTIFIER = [
    :boys_only, :girls_only, :single_parents, :patchwork_families,
    :rainbow_families, :lgbt, :grandparents, :parents
  ]
  enumerize :identifier, in: AudienceFilter::IDENTIFIER
end
