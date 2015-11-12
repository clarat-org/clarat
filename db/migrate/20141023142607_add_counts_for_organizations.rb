class AddCountsForOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :offers_count, :integer, default: 0
    add_column :organizations, :locations_count, :integer, default: 0

    reversible do |going|
      going.up do
        Organization.find_each do |orga|
          Organization.reset_counters orga.id, :offers, :locations
        end
      end
    end
  end
end
