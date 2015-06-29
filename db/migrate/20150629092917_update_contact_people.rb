class UpdateContactPeople < ActiveRecord::Migration
  def change
    add_column :contact_people, :first_name, :string
    add_column :contact_people, :last_name, :string
    add_column :contact_people, :operational_name, :string
    add_column :contact_people, :academic_title, :string
    add_column :contact_people, :gender, :string
    add_column :contact_people, :role, :string
    add_column :contact_people, :responsibility, :string

    ContactPeople.find_each do |contact_person|
      contact_person.update_column :last_name, contact_person.name
    end
  end
end
