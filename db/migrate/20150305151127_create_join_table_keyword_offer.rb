class CreateJoinTableKeywordOffer < ActiveRecord::Migration
  def change
    create_join_table :keywords, :offers do |t|
      # t.index [:keyword_id, :offer_id]
      # t.index [:offer_id, :keyword_id]
    end
  end
end
