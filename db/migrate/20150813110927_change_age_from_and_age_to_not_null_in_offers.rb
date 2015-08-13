class ChangeAgeFromAndAgeToNotNullInOffers < ActiveRecord::Migration
  def change
    Offer.where(age_from: nil).update_all age_from: 99
    Offer.where(age_to: nil).update_all age_to: 100

    change_column :offers, :age_from, :integer, null: false
    change_column :offers, :age_to, :integer, null: false
  end
end
