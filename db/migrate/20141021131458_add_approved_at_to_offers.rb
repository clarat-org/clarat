class AddApprovedAtToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :approved_at, :datetime
  end
end
