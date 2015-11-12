class AddIndices < ActiveRecord::Migration
  def change
    add_index :associated_tags, :tag_id
    add_index :associated_tags, :associated_id

    add_index :hyperlinks, [:linkable_id, :linkable_type]
    add_index :hyperlinks, :website_id

    add_index :languages_offers, :language_id
    add_index :languages_offers, :offer_id

    add_index :locations, :organization_id
    add_index :locations, :federal_state_id

    add_index :offers, :location_id
    add_index :offers, :organization_id

    add_index :offers_openings, :offer_id
    add_index :offers_openings, :opening_id

    add_index :offers_tags, :offer_id
    add_index :offers_tags, :tag_id

    add_index :search_locations, :query
    add_index :search_locations, :geoloc
  end
end
