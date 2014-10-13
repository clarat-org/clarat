class AddGeolocToSearchLocations < ActiveRecord::Migration
  def up
    add_column :search_locations, :geoloc, :string, limit: 23

    SearchLocation.find_each do |sl|
      sl.update_column :geoloc, "#{sl.latitude},#{sl.longitude}"
    end

    change_column :search_locations, :geoloc, :string, limit: 23, null: false
  end

  def down
    remove_column :search_locations, :geoloc
  end
end
