class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|
      t.string :day, limit: 3, null: false
      t.time :open, null: false
      t.time :close, null: false

      t.timestamps
    end
  end
end
