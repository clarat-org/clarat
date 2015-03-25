class LanguageFilter < Filter
  # Validations
  validates :identifier, uniqueness: true, presence: true, length: { is: 3 }
  # identifier: ISO 639-2 code

  IDENTIFIER = LanguageFilter.pluck(:identifier) # TODO: performance?
end
