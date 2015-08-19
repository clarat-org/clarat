class AddAgeLimitsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :age_from, :integer
    add_column :offers, :age_to, :integer
  end
end