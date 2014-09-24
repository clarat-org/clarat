class AddOpeningSpecificationToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :opening_specification, :string, limit: 150
    change_column :openings, :open, :time, null: true
    change_column :openings, :close, :time, null: true
  end
end
