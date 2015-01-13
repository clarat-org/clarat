class ConvertAssociatedToDependentTags < ActiveRecord::Migration
  def change
    rename_table :associated_tags, :dependent_tags
    rename_column :dependent_tags, :associated_id, :dependent_id
  end
end
