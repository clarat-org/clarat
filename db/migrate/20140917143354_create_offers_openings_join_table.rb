class CreateOffersOpeningsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :offers, :openings do |t|
      # t.index [:offer_id, :opening_id]
      # t.index [:opening_id, :offer_id]
    end
  end
end
