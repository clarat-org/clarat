class AddDisplayNameToLocations < ActiveRecord::Migration
  def up
    add_column :locations, :display_name, :string

    Location.find_each do |loc|
      loc.generate_display_name
      loc.update_column :display_name, loc.display_name
    end

    change_column :locations, :display_name, :string, null: false
  end

  def down
    remove_column :locations, :display_name, :string
  end
end
