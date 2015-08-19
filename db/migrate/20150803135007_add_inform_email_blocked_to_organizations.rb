class AddInformEmailBlockedToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :inform_email_blocked, :boolean, default: false
  end
end
