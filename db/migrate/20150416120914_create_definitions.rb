class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.string :key, limit: 50, null: false
      t.text :explanation, limit: 500, null: false

      t.timestamps
    end
  end
end
