class AddKeywordsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :keywords, :text, limit: 150
  end
end
