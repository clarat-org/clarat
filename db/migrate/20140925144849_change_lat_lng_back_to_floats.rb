class ChangeLatLngBackToFloats < ActiveRecord::Migration
  def change
    change_column :search_locations, :latitude, :float, null: false
    change_column :search_locations, :longitude, :float, null: false
    change_column :locations, :latitude, :float
    change_column :locations, :longitude, :float
  end
end
