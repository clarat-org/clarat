class AddIconToTags < ActiveRecord::Migration
  def change
    add_column :tags, :icon, :string, limit: 12
  end
end
