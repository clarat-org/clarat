class CreateOfferRelations < ActiveRecord::Migration
  def change
    create_table :offer_relations do |t|
      t.integer :offer_id, null: false
      t.integer :related_id, null: false
    end
  end
end
