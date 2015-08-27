class AddSpocToContactPeople < ActiveRecord::Migration
  def change
    add_column :contact_people, :spoc, :boolean, default: false, null: false
  end
end
