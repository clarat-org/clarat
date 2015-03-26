class AgeFilter < Filter
  extend Enumerize

  IDENTIFIER = [
    :babies, :toddler, :schoolkid, :adolescent, :young_adults, :parents,
    :grandparents
  ]
  enumerize :identifier, in: AgeFilter::IDENTIFIER
end
