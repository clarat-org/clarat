class ChangeGeolocLimitForSearchLocations < ActiveRecord::Migration
  def up
    change_column :search_locations, :geoloc, :string, limit: 35
  end

  def down
    change_column :search_locations, :geoloc, :string, limit: 23
  end
end
