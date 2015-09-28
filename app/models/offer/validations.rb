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
      validate :validate_associated_fields
      validate :only_approved_organizations, if: :approved?
      validate :age_from_fits_age_to
      validate :location_and_area_fit_encounter
      validate :location_fits_organization, on: :update
      validate :contact_people_are_choosable

      # Needs to be true before approval possible. Called in custom validation.
      # def before_approve
      #   TODO: Refactor age validations lead to simple HTML 5 checks which are
      #   eg not working in Safari. Also Rubocop complains...
      #   validate_associated_fields
      #   validate_target_audience
      # end

      private

      # Uses method from CustomValidatable concern.
      def validate_associated_fields
        validate_associated_presence :organizations
        validate_associated_presence :language_filters
        validate_associated_presence :target_audience_filters
      end

      def validate_associated_presence field
        fail_validation field, "needs_#{field}" if send(field).empty?
      end

      ## Custom Validations ##

      # Age From has to be smaller than Age To
      def age_from_fits_age_to
        return if !age_from || !age_to || age_from < age_to
        errors.add :age_from, I18n.t('offer.validations.age_from_be_smaller')
      end

      # Location is only allowed when encounter is personal, but if it is, it
      # HAS to be present. A remote offer needs an area.
      def location_and_area_fit_encounter
        if personal? && !location
          fail_validation :location, 'needs_location_when_personal'
        elsif !personal?
          fail_validation :location, 'refuses_location_when_remote' if location
          fail_validation :area, 'needs_area_when_remote' unless area
        end
      end

      # Ensure selected organization is the same as the selected location's
      # organization
      def location_fits_organization
        ids = organizations.pluck(:id)
        if personal? && location && !ids.include?(location.organization_id)
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

      # Fail if an organization added to this offer is unapproved
      def only_approved_organizations
        return unless association_instance_get(:organizations) # tests fail w/o
        if organizations.to_a.count { |orga| !orga.approved? } > 0
          approved_organization_names =
            organizations.to_a.select(&:approved?).map(&:name).join(', ')

          fail_validation :organizations, 'only_approved_organizations',
                          list: approved_organization_names
        end
      end

      # Contact people either belong to one of the Organizations or are SPoC
      def contact_people_are_choosable
        contact_people.each do |contact_person|
          next if contact_person.spoc ||
                  organizations.include?(contact_person.organization)
          # There are no intersections between both sets of orgas and not SPoC
          fail_validation :contact_people, 'contact_person_not_choosable'
        end
      end
    end
  end
end
