class AddTargetGenderToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :target_gender, :string, default: 'whatever'

    Offer.find_each do |offer|
      if offer.filters.any?{|filter| filter.identifier == 'boys_only' }
        offer.update_column :target_gender, 'boys_only'
      elsif offer.filters.any?{|filter| filter.identifier == 'girls_only' }
        offer.update_column :target_gender, 'girls_only'
      else
        offer.update_column :target_gender, 'whatever'
      end
    end
  end
end
