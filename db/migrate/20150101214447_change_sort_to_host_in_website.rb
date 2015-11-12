class ChangeSortToHostInWebsite < ActiveRecord::Migration
  def change
    rename_column :websites, :sort, :host
  end
end
