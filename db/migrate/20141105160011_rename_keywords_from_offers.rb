class RenameKeywordsFromOffers < ActiveRecord::Migration
  def change
    rename_column :offers, :keywords, :comment
    change_column :offers, :comment, :text, limit: 800
  end
end
