class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name, null: false
      t.float :minlat, null: false
      t.float :maxlat, null: false
      t.float :minlong, null: false
      t.float :maxlong, null: false

      t.timestamps
    end

    add_column :offers, :area_id, :integer
    add_index :offers, :area_id
  end
end
