class CreateOrganizationOffers < ActiveRecord::Migration
  def up
    create_table :organization_offers do |t|
      t.integer :offer_id, null: false
      t.integer :organization_id, null: false
    end

    Offer.find_each do |offer|
      OrganizationOffer.create!(
        offer_id: offer.id,
        organization_id: offer.organization_id
      )
    end
    Organization.find_each do |orga|
      Organization.reset_counters(orga.id, :offers)
    end

    remove_column :offers, :organization_id

    add_index :organization_offers, :offer_id
    add_index :organization_offers, :organization_id
  end

  def down
    add_column :offers, :organization_id, :integer

    OrganizationOffer.find_each do |oo|
      Offer.find!(oo.offer_id).update_column(
        :organization_id, oo.organization_id
      )
    end
    Organization.find_each do |orga|
      Organization.reset_counters(orga.id, :offers)
    end

    change_column :offers, :organization_id, :integer, null: false

    drop_table :organization_offers
  end
end
