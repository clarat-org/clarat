# The end point that can be contacted by a visitor to get Information about an
# offer.
class ContactPerson < ActiveRecord::Base
  # Associations
  belongs_to :organization, inverse_of: :contact_people

  has_many :contact_person_offers, inverse_of: :contact_person
  has_many :offers, through: :contact_person_offers

  # Validations
  validates :organization_id, presence: true
  validates :area_code_1, format: /\A\d*\z/, length: { maximum: 6 }
  validates :local_number_1, format: /\A\d*\z/, length: { maximum: 32 }
  validates :area_code_2, format: /\A\d*\z/, length: { maximum: 6 }
  validates :local_number_2, format: /\A\d*\z/, length: { maximum: 32 }
  validates :fax_area_code, format: /\A\d*\z/, length: { maximum: 6 }
  validates :fax_number, format: /\A\d*\z/, length: { maximum: 32 }
  validate :at_least_one_field_present

  def at_least_one_field_present
    if %w(name local_number_1 email fax_number).all? { |field| self[field].blank? }
      errors.add :base, I18n.t('validations.contact_person.incomplete')
    end
  end

  # Methods
  delegate :name, to: :organization, prefix: true, allow_nil: true

  # For rails_admin display
  def display_name
    "##{id} #{name} (#{organization_name})"
  end

  # concatenated area code and telephone number
  %w(1 2).each do |n|
    define_method "telephone_#{n}".to_sym do
      self["area_code_#{n}"].to_s + self["local_number_#{n}"]
    end
  end
end
