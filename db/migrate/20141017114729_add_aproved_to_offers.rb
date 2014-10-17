class AddAprovedToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :approved, :boolean, default: false
  end
end
