class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.boolean :main, default: false

      t.timestamps
    end
  end
end
