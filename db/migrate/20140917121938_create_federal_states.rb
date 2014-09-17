class CreateFederalStates < ActiveRecord::Migration
  def change
    create_table :federal_states do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
