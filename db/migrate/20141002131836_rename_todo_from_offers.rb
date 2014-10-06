class RenameTodoFromOffers < ActiveRecord::Migration
  def change
    rename_column :offers, :todo, :next_steps
  end
end
