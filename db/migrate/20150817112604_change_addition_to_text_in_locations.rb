class ChangeAdditionToTextInLocations < ActiveRecord::Migration
  def up
    change_column :locations, :addition, :text, limit: 255
  end

  def down
    change_column :locations, :addition, :string
  end
end
