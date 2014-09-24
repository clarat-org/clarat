class AddKeywordsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :keywords, :text, limit: 150
  end
end
