class RemoveNameFromContactPeople < ActiveRecord::Migration
  def change
    remove_column :contact_people, :name
  end
end
