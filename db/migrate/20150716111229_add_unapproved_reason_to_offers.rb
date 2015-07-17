class AddUnapprovedReasonToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :unapproved_reason, :string, default: 'not_approved'

    Offer.find_each do |offer|
      offer.update_column :unapproved_reason, 'N/A'
    end
  end
end
