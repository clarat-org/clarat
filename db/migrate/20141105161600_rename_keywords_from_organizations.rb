class RenameKeywordsFromOrganizations < ActiveRecord::Migration
  def change
    rename_column :organizations, :keywords, :comment
    change_column :organizations, :comment, :text, limit: 800
  end
end
