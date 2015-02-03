class ChangeSynonymsOfTags < ActiveRecord::Migration
  def up
    change_column :tags, :synonyms, :text, limit: 400
  end

  def down
    change_column :tags, :synonyms, :string
  end
end
