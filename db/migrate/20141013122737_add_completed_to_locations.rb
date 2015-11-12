class AddCompletedToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :completed, :boolean, default: false
  end
end
