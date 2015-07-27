class AddTargetAudienceToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :target_audience, :string
  end
end
