class AddAccreditedInstitutionToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :accredited_institution, :boolean, default: false
  end
end
