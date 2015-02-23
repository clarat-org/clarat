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

    create_table :contact_person_offers do |t|
      t.integer :offer_id, null: false
      t.integer :contact_person_id, null: false
    end

    Offer.find_each do |offer|
      ContactPerson.create(
        name: offer.contact_name
        telephone: offer.telephone
        second_telephone: offer.second_telephone
        email: offer.email
        organizations: offer.organizations
      )
    end
  end

  def down
    drop_table :contact_people
    drop_table :contact_person_offers
  end
end
