class AddCompletedToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :completed, :boolean, default: false
  end
end
