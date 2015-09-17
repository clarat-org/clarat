class RemoveClosedFromNotes < ActiveRecord::Migration
  def change
    remove_column :notes, :closed, :boolean, default: false
  end
end
