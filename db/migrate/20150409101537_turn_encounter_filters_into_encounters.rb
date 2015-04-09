class TurnEncounterFiltersIntoEncounters < ActiveRecord::Migration
  class EncounterFilter < Filter
    extend Enumerize

    IDENTIFIER = [:personal, :hotline, :online]
    enumerize :identifier, in: EncounterFilter::IDENTIFIER
  end

  class Offer < ActiveRecord::Base
    has_and_belongs_to_many :encounter_filters,
                            association_foreign_key: 'filter_id',
                            join_table: 'filters_offers'
    extend Enumerize
    enumerize :encounter, in: [:personal, :hotline, :online]
  end

  def up
    Offer.find_each do |offer|
      encounter = offer.encounter_filters.first.try(:identifier) || ''
      offer.update_column :encounter, encounter
    end

    EncounterFilter.destroy_all

    change_column :offers, :encounter, :string, length: 8
  end

  def down
    EncounterFilter::IDENTIFIER.each do |identifier|
      EncounterFilter.create identifier: identifier
    end

    Offer.find_each do |offer|
      ef = EncounterFilter.find_by_identifier offer.encounter
      offer.encounter_filters << ef
    end
  end
end
