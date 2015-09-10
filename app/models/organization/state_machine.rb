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
        state :internal_feedback # There was an issue (internal)
        state :external_feedback # There was an issue (external)

        ## Transitions

        event :complete do
          transitions from: :initialized, to: :completed
        end

        event :approve, before: :set_approved_information do
          transitions from: :completed, to: :approved, guard: :different_actor?
          transitions from: :internal_feedback, to: :approved
          transitions from: :external_feedback, to: :approved
        end

        event :deactivate_internal, after: :deactivate_and_inform_offers do
          transitions from: :approved, to: :internal_feedback
          transitions from: :external_feedback, to: :internal_feedback
        end

        event :deactivate_external, after: :deactivate_and_inform_offers do
          transitions from: :approved, to: :external_feedback
          transitions from: :internal_feedback, to: :external_feedback
        end
      end

      def deactivate_and_inform_offers
        offers.approved.find_each do |offer|
          action =
            internal_feedback? ? 'deactivate_internal!' : 'deactivate_external!'

          raise '#deactivate_and_inform_offers' unless offer.public_send action
          offer.notes.create!(
            topic: :history,
            user_id: User.system_user.id,
            text:
              I18n.t("offer.deactivate_and_inform_offers.#{action}", orga: name)
          )
        end
      end
    end
  end
end
