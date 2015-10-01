# The end point that can be contacted by a visitor to get Information about an
# offer.
class ContactPerson < ActiveRecord::Base
  # Concerns
  include Notable, NoteReferencable

  # Associations
  belongs_to :organization, inverse_of: :contact_people
  belongs_to :email, inverse_of: :contact_people

  has_many :contact_person_offers, inverse_of: :contact_person
  has_many :offers, through: :contact_person_offers, inverse_of: :contact_people

  # Enumerization
  extend Enumerize
  enumerize :gender, in: %w(female male)
  enumerize :academic_title, in: %w(dr prof_dr)

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
    one_field_blank = %w(first_name last_name operational_name local_number_1
                         fax_number email_id).all? do |field|
      self[field].blank?
    end

    if one_field_blank
      errors.add :base, I18n.t('contact_person.validations.incomplete')
    end
  end

  # Methods
  delegate :name, to: :organization, prefix: true, allow_nil: true
  delegate :address, :address?, to: :email, prefix: true, allow_nil: true

  # For rails_admin display
  def display_name
    if first_name.blank? && last_name.blank?
      "##{id} #{operational_name} (#{organization_name})"
    else
      "##{id} #{first_name} #{last_name} (#{organization_name})".squeeze(' ')
    end
  end

  # concatenated area code and telephone number
  %w(1 2).each do |n|
    define_method "telephone_#{n}".to_sym do
      self["area_code_#{n}"].to_s + self["local_number_#{n}"]
    end
  end

  def fax
    fax_area_code.to_s + fax_number
  end

  def partial_dup
    self.dup.tap do |contact_person|
      contact_person.offers = self.offers
    end
  end
end
