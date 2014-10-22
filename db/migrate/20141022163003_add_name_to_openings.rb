class AddNameToOpenings < ActiveRecord::Migration
  def up
    add_column :openings, :name, :string

    Opening.find_each(&:save)

    change_column :openings, :name, :string, null: false
  end

  def down
    remove_column :openings, :name
  end
end
