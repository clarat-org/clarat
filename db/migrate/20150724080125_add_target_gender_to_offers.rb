class AddTargetGenderToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :target_gender, :string, default: 'whatever'
  end
end