class ChangeCodeLimitToLanguages < ActiveRecord::Migration
  def change
    change_column :languages, :code, :string, limit: 3
  end
end
