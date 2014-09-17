class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name, null: false
      t.string :code, null: false, limit: 2

      t.timestamps
    end
  end
end
