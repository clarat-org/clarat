class Offer
  module Validations
    extend ActiveSupport::Concern

    included do
      validates :name, length: { maximum: 80 }, presence: true
      validates :name,
                uniqueness: { scope: :location_id },
                unless: ->(offer) { offer.location.nil? }
      validates :description, length: { maximum: 450 }, presence: true
      validates :next_steps, length: { maximum: 500 }, presence: true
      validates :encounter, presence: true
      validates :fax, format: /\A\d*\z/, length: { maximum: 32 }
      validates :opening_specification, length: { maximum: 400 }
      validates :legal_information, length: { maximum: 400 }
      validates :comment, length: { maximum: 800 }

      # Custom validations
      validate :location_fits_organization, on: :update
      validates :approved, approved: true

      # Needs to be true before approval possible. Called in custom validation.
      def before_approve
        validate_associated_presence :organizations
        if organizations.where(approved: false).count > 0
          fail_validation :organizations, 'only_approved_organizations',
                          list: organizations.approved.pluck(:name).join(', ')
        end
        validate_associated_presence :encounter_filters
        validate_associated_presence :age_filters
      end

      private

      def validate_associated_presence field
        fail_validation field, "needs_#{field}" if send(field).count == 0
      end

      def fail_validation field, i18n_selector, options = {}
        errors[field] = I18n.t("validations.offer.#{i18n_selector}", options)
      end

      # Custom Validation: Ensure selected organization is the same as the
      # selected location's organization
      def location_fits_organization
        ids = organizations.pluck(:id)
        if location && !ids.include?(location.organization_id)
          errors.add(:location_id, I18n.t(
            'validations.offer.location_fits_organization.location_error'))
          errors.add(:organizations, I18n.t(
            'validations.offer.location_fits_organization.organization_error'))
        end
      end
    end
  end
end
