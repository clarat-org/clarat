class AddAgeLimitsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :age_from, :integer
    add_column :offers, :age_to, :integer

    Offer.find_each do |offer|
      puts offer.id
      if offer.filters.any?{|filter| filter.identifier == "babies"}
        offer.update_column :age_from, 0
      elsif offer.filters.any?{|filter| filter.identifier == "toddler"}
        offer.update_column :age_from, 1
      elsif offer.filters.any?{|filter| filter.identifier == "schoolkid"}
        offer.update_column :age_from, 6
      elsif offer.filters.any?{|filter| filter.identifier == "adolescent"}
        offer.update_column :age_from, 14
      end

      if offer.filters.any?{|filter| filter.identifier == "adolescent"}
        offer.update_column :age_to, 18
      elsif offer.filters.any?{|filter| filter.identifier == "schoolkid"}
        offer.update_column :age_to, 14
      elsif offer.filters.any?{|filter| filter.identifier == "toddler"}
        offer.update_column :age_to, 6
      elsif offer.filters.any?{|filter| filter.identifier == "babies"}
        offer.update_column :age_to, 1
      end
    end
  end
end