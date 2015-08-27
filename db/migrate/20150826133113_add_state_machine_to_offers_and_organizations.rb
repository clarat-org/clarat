class AddStateMachineToOffersAndOrganizations < ActiveRecord::Migration
  def up
    add_column :offers, :aasm_state, :string, limit: 32
    add_column :organizations, :aasm_state, :string, limit: 32

    Offer.where(approved: true).update_all aasm_state: :approved
    Offer.where(
      approved: false, completed: true, unapproved_reason: 'N/A'
    ).update_all aasm_state: :completed
    Offer.where(
      approved: false, completed: true, unapproved_reason: :not_approved
    ).update_all aasm_state: :completed
    Offer.where(
      approved: false, completed: true, unapproved_reason: :expired
    ).update_all aasm_state: :expired
    Offer.where(
      approved: false, completed: true, unapproved_reason: :paused
    ).update_all aasm_state: :paused
    Offer.where(
      approved: false, completed: true, unapproved_reason: :internal_review
    ).update_all aasm_state: :internal_feedback
    Offer.where(
      approved: false, completed: true, unapproved_reason: :external_feedback
    ).update_all aasm_state: :external_feedback

    Organization.where(approved: true).update_all aasm_state: :approved
    Organization.where(
      approved: false, completed: true
    ).update_all aasm_state: :completed

    remove_column :offers, :approved
    remove_column :offers, :completed
    remove_column :offers, :unapproved_reason

    remove_column :organizations, :approved
    remove_column :organizations, :completed
  end
end
