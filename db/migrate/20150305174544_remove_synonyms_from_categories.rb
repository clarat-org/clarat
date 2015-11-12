class RemoveSynonymsFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :synonyms, :string
  end
end
