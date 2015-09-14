class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :topic, null: false, limit: 40
      t.integer :user_id
      t.date :x, null: false
      t.integer :y, null: false
    end

    add_index :statistics, :user_id
    # TODO: we will probably need a specific index for external access, like:
    # add_index :statistics, [:topic, :x, :user_id]
    # add_index :statistics, [:topic, :x]

    # Also add state indix to offer and organization to enable faster statistics
    # access
    add_index :offers, :aasm_state
    add_index :organizations, :aasm_state
  end
end
