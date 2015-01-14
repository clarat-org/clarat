class ChangeAdminToRole < ActiveRecord::Migration
  def up
    rename_column :users, :admin, :role
    change_column :users, :role, :string, default: 'standard'

    User.find_each do |user|
      if user.role == 'true'
        user.update_column :role, 'researcher'
      else
        user.update_column :role, 'standard'
      end
    end
  end

  def down
    add_column :users, :admin, :boolean, default: false

    User.reset_column_information
    User.find_each do |user|
      if user.role == 'standard'
        user.update_column :admin, false
      else
        user.update_column :admin, true
      end
    end

    remove_column :users, :role
  end
end
