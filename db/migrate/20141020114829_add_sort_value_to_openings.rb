class AddSortValueToOpenings < ActiveRecord::Migration
  def change
    add_column :openings, :sort_value, :integer
  end
end
