class AddAwesomeNestedSetToCategories < ActiveRecord::Migration
  def up
    ### Add AwesomeNestedSet Fields ###
    add_column :categories, :parent_id, :integer, index: true
    add_column :categories, :lft,       :integer, index: true
    add_column :categories, :rgt,       :integer, index: true

    # optional fields
    add_column :categories, :depth,          :integer
    add_column :categories, :children_count, :integer, default: 0

    # This is necessary to update :lft and :rgt columns
    # Category.rebuild!

    change_column :categories, :lft,            :integer, null: false
    change_column :categories, :rgt,            :integer, null: false
    change_column :categories, :children_count, :integer, null: false
    # change_column :categories, :depth,          :integer, null: false
  end

  def self.down
    ### Remove AwesomeNestedSet ###
    remove_column :categories, :parent_id
    remove_column :categories, :lft
    remove_column :categories, :rgt

    # optional fields
    remove_column :categories, :depth
    remove_column :categories, :children_count
  end
end
