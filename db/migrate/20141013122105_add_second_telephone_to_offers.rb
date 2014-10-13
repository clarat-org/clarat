class AddSecondTelephoneToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :second_telephone, :string
  end
end
