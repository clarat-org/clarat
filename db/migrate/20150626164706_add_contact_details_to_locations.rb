class AddContactDetailsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :area_code, :string, limit: 6
    add_column :locations, :local_number, :string, limit: 32
    add_column :locations, :email, :string
  end
end
