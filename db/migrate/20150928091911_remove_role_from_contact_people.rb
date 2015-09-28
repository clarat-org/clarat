class RemoveRoleFromContactPeople < ActiveRecord::Migration
  def change
    remove_column :contact_people, :role
  end
end
