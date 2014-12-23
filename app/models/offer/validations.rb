class Offer
  module Validations
    extend ActiveSupport::Concern

    included do
      validates :name, length: { maximum: 80 }, presence: true
      validates :name,
                uniqueness: { scope: :location_id },
                unless: ->(offer) { offer.location.nil? }
      validates :description, length: { maximum: 400 }, presence: true
      validates :next_steps, length: { maximum: 500 }, presence: true
      validates :encounter, presence: true
      validates :fax, format: /\A\d*\z/, length: { maximum: 32 }
      validates :telephone, format: /\A\d*\z/, length: { maximum: 32 }
      validates :second_telephone, format: /\A\d*\z/, length: { maximum: 32 }
      validates :opening_specification, length: { maximum: 400 }
      validates :legal_information, length: { maximum: 400 }
      validates :comment, length: { maximum: 800 }
      validates :organization_id, presence: true
      validates :approved, approved: true

      # Custom validations
      validate :location_fits_organization
      validates :approved, approved: true

      private

      # Custom Validation: Ensure selected organization is the same as the selected location's organization
      def location_fits_organization
        if location && location.organization_id != organization_id
          errors.add(:location_id, I18n.t(
            'validations.offer.location_fits_organization.location_error'))
          errors.add(:organization_id, I18n.t(
            'validations.offer.location_fits_organization.organization_error'))
        end
      end
    end
  end
end
