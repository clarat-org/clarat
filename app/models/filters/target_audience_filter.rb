class TargetAudienceFilter < Filter
  validates :identifier, uniqueness: true, presence: true

  IDENTIFIER = %w(children parents nuclear_family aquintances pregnant_woman)
end
