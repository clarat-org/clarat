class RemoveNullConstrainFromOfferEncounter < ActiveRecord::Migration
  def change
    change_column :offers, :encounter, :string, null: true
  end
end
