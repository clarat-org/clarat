class AddLegalInformationToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :legal_information, :text, limit: 400
  end
end
