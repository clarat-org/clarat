class AddStateMachineToOffersAndOrganizations < ActiveRecord::Migration
  def change
    add_column :offers, :aasm_state, :string, limit: 32
    add_column :organizations, :aasm_state, :string, limit: 32
  end
end
