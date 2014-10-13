class CreateHyperlinks < ActiveRecord::Migration
  def up
    create_table :hyperlinks do |t|
      t.integer :linkable_id, null: false
      t.string :linkable_type, null: false, limit: 40
      t.integer :website_id, null: false
    end

    Website.find_each do |website|
      Hyperlink.create(
        linkable_id: website.linkable_id,
        linkable_type: website.linkable_type,
        website_id: website.id
      )
    end

    remove_column :websites, :linkable_id
    remove_column :websites, :linkable_type
  end

  def down
    add_column :websites, :linkable_id, :integer
    add_column :websites, :linkable_type, :string

    Hyperlink.find_each do |link|
      Website.find(link.website_id).update_attributes(
        linkable_id: link.linkable_id,
        linkable_type: link.linkable_type
      )
    end

    drop_table :hyperlinks
  end
end
