class CreateUpdateRequests < ActiveRecord::Migration
  def change
    create_table :update_requests do |t|
      t.string :search_location, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
