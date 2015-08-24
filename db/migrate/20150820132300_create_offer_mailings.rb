class CreateOfferMailings < ActiveRecord::Migration
  def change
    create_table :offer_mailings do |t|
      t.integer :offer_id, null: false
      t.integer :email_id, null: false
      t.string :mailing_type, limit: 16, null: false

      t.timestamps
    end

    add_index :offer_mailings, :offer_id
    add_index :offer_mailings, :email_id

    rename_column :organizations, :inform_email_blocked, :mailings_enabled

    remove_column :emails, :log, :string, null: false, default: ''
  end
end
