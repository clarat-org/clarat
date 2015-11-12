class CustomizeUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    change_column :users, :email, :string, null: false
  end
end
