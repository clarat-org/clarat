class RenameReachFromOffers < ActiveRecord::Migration
  def change
    rename_column :offers, :reach, :encounter
  end
end
