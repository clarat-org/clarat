class RemoveDefaultFromTargetGenderInOffers < ActiveRecord::Migration
  def change
    change_column_default :offers, :target_gender, nil
  end
end
