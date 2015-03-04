class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name
      t.text :synonyms
      t.integer :offer_id
    end

    add_index :keywords, :offer_id
  end
end
