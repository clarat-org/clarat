class AudienceFilter < Filter
  extend Enumerize

  IDENTIFIER = [
    :boys_only, :girls_only, :single_parents, :patchwork_families,
    :rainbow_families, :lgbt
  ]
  enumerize :identifier, in: AudienceFilter::IDENTIFIER
end
