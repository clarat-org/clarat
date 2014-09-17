class CreateAssociatedTagsJoinTable < ActiveRecord::Migration
  def change
    create_table :associated_tags do |t|
      t.integer :tag_id, :associated_id
      # t.index [:tag_id, :associated_id]
      # t.index [:associated_id, :tag_id]
    end
  end
end
