class AddIndicesForBackend < ActiveRecord::Migration
  def change
    # for statistics
    add_index :offers, :created_at
    add_index :offers, :approved_at

    add_index :organizations, :created_at
    add_index :organizations, :approved_at

    add_index :locations, :created_at

    # for selection search
    add_index :openings, :day
    add_index :openings, :name

    add_index :tags, :name

    add_index :websites, :url
    add_index :websites, :sort
  end
end
