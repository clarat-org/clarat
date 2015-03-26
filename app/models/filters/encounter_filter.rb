class EncounterFilter < Filter
  extend Enumerize

  IDENTIFIER = [:personal, :hotline, :online]
  enumerize :identifier, in: EncounterFilter::IDENTIFIER
end
