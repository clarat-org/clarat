class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :text, limit: 800, null: false
      t.string :topic, limit: 32
      t.boolean :closed, default: false

      t.integer :user_id, null: false

      t.integer :notable_id, null: false
      t.string :notable_type, limit: 64, null: false

      t.integer :referencable_id, null: true
      t.string :referencable_type, limit: 64, null: true

      t.timestamps
    end

    add_index :notes, :user_id
    add_index :notes, [:notable_id, :notable_type]
    add_index :notes, [:referencable_id, :referencable_type]
  end
end
