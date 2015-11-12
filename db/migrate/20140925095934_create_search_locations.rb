class CreateSearchLocations < ActiveRecord::Migration
  def change
    create_table :search_locations do |t|
      t.string :query, null: false
      t.decimal :latitude, precision: 10, scale: 10, null: false #precision 7 would be enough for 1cm accuracy
      t.decimal :longitude, precision: 10, scale: 10, null: false

      t.timestamps
    end
  end
end
