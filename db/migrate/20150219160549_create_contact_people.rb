class CreateContactPeople < ActiveRecord::Migration
  def up
    create_table :contact_people do |t|
      t.string :name
      t.string :telephone
      t.string :second_telephone
      t.string :email
      t.integer :organization_id, null: false

      t.timestamps
    end
    add_index :contact_people, :organization_id

    create_table :contact_person_offers do |t|
      t.integer :offer_id, null: false
      t.integer :contact_person_id, null: false
    end
    add_index :contact_person_offers, :offer_id
    add_index :contact_person_offers, :contact_person_id

    Offer.find_each do |offer|
      cp = ContactPerson.new(
        name: offer.contact_name,
        telephone: offer.telephone,
        second_telephone: offer.second_telephone,
        email: offer.email,
        organization_id: offer.organizations.first.id
      )
      cp.save(validate: false)
      offer.contact_people << cp
    end

    remove_column :offers, :contact_name
    remove_column :offers, :telephone
    remove_column :offers, :second_telephone
    remove_column :offers, :email
  end

  def down
    drop_table :contact_people
    drop_table :contact_person_offers

    add_column :offers, :contact_name
    add_column :offers, :telephone
    add_column :offers, :second_telephone
    add_column :offers, :email
  end
end
