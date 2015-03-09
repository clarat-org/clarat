class TelephoneDataChanges < ActiveRecord::Migration
  def up
    remove_column :locations, :email, :string
    remove_column :locations, :fax, :string, limit: 32
    remove_column :locations, :telephone, :string, limit: 32
    remove_column :locations, :second_telephone, :string, limit: 32

    add_column :contact_people, :area_code_1, :string, limit: 6
    add_column :contact_people, :local_number_1, :string, limit: 32
    add_column :contact_people, :area_code_2, :string, limit: 6
    add_column :contact_people, :local_number_2, :string, limit: 32

    ContactPerson.find_each do |cp|
      cp.update_column :local_number_1, cp.telephone
      cp.update_column :local_number_2, cp.second_telephone
    end

    remove_column :contact_people, :telephone, :string
    remove_column :contact_people, :second_telephone, :string
  end

  def down
    add_column :locations, :email, :string
    add_column :locations, :fax, :string, limit: 32
    add_column :locations, :telephone, :string, limit: 32
    add_column :locations, :second_telephone, :string, limit: 32

    remove_column :contact_people, :area_code_1, :string, limit: 6
    remove_column :contact_people, :local_number_1, :string, limit: 32
    remove_column :contact_people, :area_code_2, :string, limit: 6
    remove_column :contact_people, :local_number_2, :string, limit: 32

    ContactPerson.find_each do |cp|
      cp.update_column :telephone,
                       (cp.area_code_1.to_s + cp.local_number_1)
      cp.update_column :second_telephone,
                       (cp.area_code_2.to_s + cp.local_number_2)
    end

    add_column :contact_people, :telephone, :string
    add_column :contact_people, :second_telephone, :string
  end
end
