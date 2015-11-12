class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :sort, null: false
      t.string :url, null: false
      t.integer :linkable_id
      t.string :linkable_type

      t.timestamps
    end
  end
end
