class ChangeOpeningSpecificationsFromOffers < ActiveRecord::Migration
  def change
    change_column :offers, :opening_specification, :text, limit: 400
  end
end
