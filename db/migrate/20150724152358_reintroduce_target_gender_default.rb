class ReintroduceTargetGenderDefault < ActiveRecord::Migration
  def change
    change_column_default :offers, :target_gender, 'whatever'
  end
end
