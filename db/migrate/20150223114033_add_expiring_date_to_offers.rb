class AddExpiringDateToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :expires_at, :timestamp
  end
end
