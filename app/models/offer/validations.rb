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
      validates :opening_specification, length: { maximum: 400 }
      validates :legal_information, length: { maximum: 400 }
      validates :comment, length: { maximum: 800 }
      validates :slug, uniqueness: true
      validates :encounter, presence: true
      validates :expires_at, presence: true
      validates :expires_at, later_date: true, on: :create
      validates :age_from, numericality: { greater_than: -1, less_than_or_equal_to: 14, only_integer: true }
      validates :age_to, numericality: { greater_than: 0, less_than_or_equal_to: 18, only_integer: true }


      # Custom validations
      validate :location_fits_organization, on: :update
      validates :approved, approved: true

      # Needs to be true before approval possible. Called in custom validation.
      # Uses method from CustomValidatable concern.
      def before_approve
         # TODO: Refactor age validations lead to simple HTML 5 checks which are
         # eg not working in Safari. Also Rubocop complains...
        validate_age_filter
        validate_associated_fields
        if organizations.where(approved: false).count > 0
          fail_validation :organizations, 'only_approved_organizations',
                          list: organizations.approved.pluck(:name).join(', ')
        end
        fail_validation :area, 'needs_area_when_remote' if !personal? && !area
      end

      private

      def validate_age_filter
        fail_validation :age_from, 'needs_age' unless age_from
        fail_validation :age_to, 'needs_age' unless age_to
        if age_from > age_to
          errors.add(:age_from, 'fuck off!')
        end
      end

      def validate_associated_fields
        validate_associated_presence :organizations
        validate_associated_presence :language_filters
      end

      def validate_associated_presence field
        fail_validation field, "needs_#{field}" if send(field).count == 0
      end

      # Custom Validation: Ensure selected organization is the same as the
      # selected location's organization
      def location_fits_organization
        ids = organizations.pluck(:id)
        if location && !ids.include?(location.organization_id)
          errors.add(
            :location_id,
            I18n.t(
              'offer.validations.location_fits_organization.location_error'
            ))
          errors.add(
            :organizations,
            I18n.t(
              'offer.validations.location_fits_organization.organization_error'
            ))
        end
      end
    end
  end
end
