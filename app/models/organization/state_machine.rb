class Organization
  module StateMachine
    extend ActiveSupport::Concern

    included do
      include AASM
      aasm do
        ## States

        state :initialized, initial: true
        state :completed
        state :approved

        # Special states object might enter after it was approved
        state :internal_feedback, # There was an issue (internal)
              after_enter: :deactivate_offers!,
              after_exit: :reactivate_offers!
        state :external_feedback, # There was an issue (external)
              after_enter: :deactivate_offers!,
              after_exit: :reactivate_offers!

        ## Transitions

        event :complete do
          transitions from: :initialized, to: :completed
        end

        event :approve, before: :set_approved_information do
          transitions from: :completed, to: :approved, guard: :different_actor?
          transitions from: :internal_feedback, to: :approved
          transitions from: :external_feedback, to: :approved
        end

        event :deactivate_internal do
          transitions from: :approved, to: :internal_feedback
          transitions from: :external_feedback, to: :internal_feedback
        end

        event :deactivate_external do
          transitions from: :approved, to: :external_feedback
          transitions from: :internal_feedback, to: :external_feedback
        end
      end

      # When an organization switches from approved to an unapproved state,
      # also deactivate all it's associated approved offers
      def deactivate_offers!
        offers.approved.find_each do |offer|
          next if offer.deactivate_through_organization!
          raise "#deactivate_offers! failed for #{offer.id}"
        end
      end

      # When an organization switches from an unapproved state to approved,
      # also reactivate all it's associated organization_deactivated offers
      # (if possible)
      def reactivate_offers!
        offers.where(aasm_state: 'organization_deactivated').find_each do |o|
          o.approve! if o.may_approve?
        end
      end
    end
  end
end
