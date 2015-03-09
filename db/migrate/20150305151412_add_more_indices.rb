class AddMoreIndices < ActiveRecord::Migration
  def change
    add_index :keywords_offers, :offer_id
    add_index :keywords_offers, :keyword_id
  end
end
