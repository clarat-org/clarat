class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :street, null: false
      t.string :addition
      t.string :zip, null: false
      t.string :city, null: false
      t.string :telephone
      t.string :email
      t.boolean :hq
      t.float :latitude
      t.float :longitude

      t.integer :organization_id, null: false
      t.integer :federal_state_id, null: false

      t.timestamps
    end
  end
end
