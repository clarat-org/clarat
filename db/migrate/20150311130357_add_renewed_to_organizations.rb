class AddRenewedToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :renewed, :boolean, default: false
  end
end
