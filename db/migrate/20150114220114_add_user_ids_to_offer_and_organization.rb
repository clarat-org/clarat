class AddUserIdsToOfferAndOrganization < ActiveRecord::Migration
  def up
    add_column :offers, :created_by, :integer
    add_column :offers, :approved_by, :integer

    Offer.find_each do |offer|
      creator = offer.versions.first.whodunnit.to_i
      offer.update_column(:created_by, creator) if creator > 0

      if offer.approved?
        approver = offer.versions.select do |v|
          v.object_changes.match /approved:\n- false\n- true/
        end.first.try(:whodunnit).try(:to_i)
        offer.update_column(:approved_by, approver) if approver and approver > 0
      end
    end

    add_column :organizations, :created_by, :integer
    add_column :organizations, :approved_by, :integer

    Organization.find_each do |orga|
      creator = orga.versions.first.whodunnit.to_i
      orga.update_column(:created_by, creator) if creator > 0

      if orga.approved?
        approver = orga.versions.select do |v|
          v.object_changes.match /approved:\n- false\n- true/
        end.first.try(:whodunnit).try(:to_i)
        orga.update_column(:approved_by, approver) if approver and approver > 0
      end
    end
  end

  def down
    remove_column :offers, :created_by
    remove_column :offers, :approved_by
    remove_column :organizations, :created_by
    remove_column :organizations, :approved_by
  end
end
