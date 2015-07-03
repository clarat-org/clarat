class UpdateContactPeople < ActiveRecord::Migration
  def change
    add_column :contact_people, :first_name, :string
    add_column :contact_people, :last_name, :string
    add_column :contact_people, :operational_name, :string
    add_column :contact_people, :academic_title, :string
    add_column :contact_people, :gender, :string
    add_column :contact_people, :role, :string
    add_column :contact_people, :responsibility, :string
  end
end
