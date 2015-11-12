class CreateLanguagesOffersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :languages, :offers do |t|
      # t.index [:language_id, :offer_id]
      # t.index [:offer_id, :language_id]
    end
  end
end
