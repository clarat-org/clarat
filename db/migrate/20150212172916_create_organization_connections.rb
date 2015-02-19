class CreateOrganizationConnections < ActiveRecord::Migration
  def change
    create_table :organization_connections do |t|
      t.integer :parent_id, null: false
      t.integer :child_id, null: false
    end

    add_index :organization_connections, :parent_id
    add_index :organization_connections, :child_id
  end
end
