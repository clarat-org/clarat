class ChangeOffersLocationId < ActiveRecord::Migration
  def change
    change_column :offers, :location_id,  :integer, null: true
  end
end
