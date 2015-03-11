class FrequentChangesToExpiresAt < ActiveRecord::Migration
  def up
    remove_column :offers, :frequent_changes

    Offer.where(expires_at: nil).find_each do |offer|
      offer.update_column :expires_at, (offer.created_at + 1.year)
    end

    change_column :offers, :expires_at, :date, null: false
  end

  def down
    add_column :offers, :frequent_changes, :boolean, default: false

    change_column :offers, :expires_at, :datetime, null: true
  end
end
