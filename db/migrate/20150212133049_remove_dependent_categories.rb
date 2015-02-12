class RemoveDependentCategories < ActiveRecord::Migration
  def up
    drop_table :dependent_categories
    drop_table :dependent_tags
  end
end
