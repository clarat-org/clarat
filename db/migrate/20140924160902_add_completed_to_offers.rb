class AddCompletedToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :completed, :boolean, default: false
  end
end
