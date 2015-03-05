class AddRenewedToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :renewed, :boolean, default: false
  end
end
