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
      validates :age_from,
                numericality: { greater_than_or_equal_to: 0,
                                less_than_or_equal_to: 17, only_integer: true,
                                allow_blank: false },
                presence: true
      validates :age_to,
                numericality: { greater_than: 0, less_than_or_equal_to: 18,
                                only_integer: true, allow_blank: false },
                presence: true

      # Custom validations
      validate :age_from_fits_age_to
      validate :location_fits_organization, on: :update
      validates :approved, approved: true

      # Needs to be true before approval possible. Called in custom validation.
      # Uses method from CustomValidatable concern.
      def before_approve
        # TODO: Refactor age validations lead to simple HTML 5 checks which are
        # eg not working in Safari. Also Rubocop complains...
        validate_associated_fields
        validate_target_audience
        validate_organizations
        fail_validation :area, 'needs_area_when_remote' if !personal? && !area
      end

      def validate_organizations
        if organizations.where(approved: false).count > 0
          fail_validation :organizations, 'only_approved_organizations',
                          list: organizations.approved.pluck(:name).join(', ')
        end
      end

      private

      def validate_target_audience
        unless target_audience
          fail_validation :target_audience, 'is_needed'
        end
      end

      def validate_associated_fields
        validate_associated_presence :organizations
        validate_associated_presence :language_filters
      end

      def validate_organizations
        if organizations.where(approved: false).count > 0
          fail_validation :organizations, 'only_approved_organizations',
                          list: organizations.approved.pluck(:name).join(', ')
        end
      end

      def validate_associated_presence field
        fail_validation field, "needs_#{field}" if send(field).count == 0
      end

      # Custom Validation : Age From has to be smaller than Age To
      def age_from_fits_age_to
        return if !age_from || !age_to || age_from < age_to
        errors.add :age_from, I18n.t('offer.validations.age_from_be_smaller')
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
