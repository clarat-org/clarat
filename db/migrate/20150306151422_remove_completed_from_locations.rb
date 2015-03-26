class RemoveCompletedFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :completed, :boolean
  end
end
