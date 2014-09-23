class AddFaxToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :fax, :string, limit: 32
    change_column :offers, :telephone, :string, limit: 32
    change_column :locations, :telephone, :string, limit: 32
    change_column :locations, :second_telephone, :string, limit: 32
    change_column :locations, :fax, :string, limit: 32
  end
end
