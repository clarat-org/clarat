class TargetAudienceFilter < Filter
  validates :identifier, uniqueness: true, presence: true

  IDENTIFIER = %w(children parents family acquintances pregnant_woman)
end
