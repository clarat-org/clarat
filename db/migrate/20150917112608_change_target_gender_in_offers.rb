class ChangeTargetGenderInOffers < ActiveRecord::Migration
  def up
    rename_column :offers, :target_gender, :exclusive_gender
    change_column :offers, :exclusive_gender, :string, null: true, default: nil

    Offer.where(exclusive_gender: 'whatever').update_all(exclusive_gender: nil)
  end

  def down
    rename_column :offers, :exclusive_gender, :target_gender
    change_column :offers, :target_gender, :string, default: 'whatever'

    Offer.where(exclusive_gender: nil).update_all(exclusive_gender: 'whatever')
  end
end
