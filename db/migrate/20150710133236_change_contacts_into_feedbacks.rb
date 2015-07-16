class ChangeContactsIntoFeedbacks < ActiveRecord::Migration
  def change
    rename_table :contacts, :feedbacks
  end
end
