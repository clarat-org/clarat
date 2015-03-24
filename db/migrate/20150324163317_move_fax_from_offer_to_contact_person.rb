class MoveFaxFromOfferToContactPerson < ActiveRecord::Migration
  def change
    add_column :contact_people, :fax_area_code, :string, limit: 6
    add_column :contact_people, :fax_number, :string, limit: 32

    Offer.find_each do |offer|
      cp = ContactPerson.new(
        fax_number: offer.fax,
        organization_id: offer.organizations.first.id
      )
      cp.save(validate: false)
      offer.contact_people << cp
    end

    remove_column :offers, :fax, :string
  end
end
