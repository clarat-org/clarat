class AddDescriptionHtmlToOrganizations < ActiveRecord::Migration
  def up
    add_column :organizations, :description_html, :text, limit: 550

    Organization.find_each do |orga|
      orga.update_column(
        :description_html, MarkdownRenderer.render(orga.description)
      )
    end
  end

  def down
    remove_column :organizations, :description_html
  end
end
