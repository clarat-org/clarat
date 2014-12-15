class ChangeNextStepsFromOffers < ActiveRecord::Migration
  def change
    change_column :offers, :next_steps, :text, limit: 500
  end
end
