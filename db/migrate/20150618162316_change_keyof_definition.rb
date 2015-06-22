class ChangeKeyofDefinition < ActiveRecord::Migration
  def change
    change_column :definitions, :key, :string, :limit => 255
  end
end
