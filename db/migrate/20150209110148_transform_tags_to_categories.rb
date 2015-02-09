class TransformTagsToCategories < ActiveRecord::Migration
  def up
    rename_table :tags, :categories

    rename_table :dependent_tags, :dependent_categories
    rename_column :dependent_categories, :tag_id, :category_id

    rename_table :offers_tags, :categories_offers
    rename_column :categories_offers, :tag_id, :category_id

    remove_column :categories, :main
  end

  def down
    ### Former Table Structure ###
    rename_table :categories, :tags

    rename_table :dependent_categories, :dependent_tags
    rename_column :dependent_tags, :category_id, :tag_id

    rename_table :categories_offers, :offers_tags
    rename_column :offers_tags, :category_id, :tag_id

    add_column :tags, :main, :boolean, default: false
  end
end
