class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.text :description, limit: 400, null: false
      t.string :legal_form, null: false
      t.boolean :charitable, default: true
      t.integer :founded, limit: 4
      t.string :classification, null: false
      t.string :slug

      t.timestamps
    end
  end
end
