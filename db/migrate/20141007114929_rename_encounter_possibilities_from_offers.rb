class RenameEncounterPossibilitiesFromOffers < ActiveRecord::Migration
  class Offer < ActiveRecord::Base
    extend Enumerize
    enumerize :encounter, in: %w[local variable national fixed determinable
      independent]
  end

  def change
    Offer.all.each do |offer|
      if offer.encounter == 'local'
        offer.update_column(:encounter, 'fixed')
      elsif offer.encounter == 'variable'
        offer.update_column(:encounter, 'determinable')
      elsif offer.encounter == 'national'
        offer.update_column(:encounter, 'independent')
      end
    end
  end
end
