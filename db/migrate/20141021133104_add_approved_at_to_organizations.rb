class AddApprovedAtToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :approved_at, :datetime
  end
end
