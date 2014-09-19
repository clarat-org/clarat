class ChangeOrganizationsClassification < ActiveRecord::Migration
  def change
    change_column :organizations, :classification,  :string, null: true
  end
end
