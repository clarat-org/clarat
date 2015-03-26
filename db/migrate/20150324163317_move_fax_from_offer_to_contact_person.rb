class MoveFaxFromOfferToContactPerson < ActiveRecord::Migration
  def change
    add_column :contact_people, :fax_area_code, :string, limit: 6
    add_column :contact_people, :fax_number, :string, limit: 32

    Offer.where.not(fax: '').find_each do |offer|
      empty_contact = offer.contact_people.where(name: "").first
      if empty_contact
        empty_contact.fax_number = offer.fax
        empty_contact.save(validate: false)
      elsif offer.organizations.count > 0
        cp = ContactPerson.new(
          fax_number: offer.fax,
          organization_id: offer.organizations.first.id
        )
        cp.save(validate: false)
        offer.contact_people << cp
      end
    end

    remove_column :offers, :fax, :string
  end
end
