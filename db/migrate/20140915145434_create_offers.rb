class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :name, null: false, limit: 80
      t.text :description, null: false, limit: 400
      t.text :todo, limit: 400
      t.string :telephone
      t.string :contact_name
      t.string :email
      t.string :reach, null: false
      t.boolean :frequent_changes, default: false
      t.string :slug

      t.integer :location_id, null: false

      t.timestamps
    end
  end
end
