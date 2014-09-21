class AddDetailsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :second_telephone, :string
    add_column :locations, :fax, :string
  end
end
