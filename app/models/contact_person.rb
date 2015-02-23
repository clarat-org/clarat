class ContactPerson < ActiveRecord::Base
  # Associations
  belongs_to :organization, inverse_of: :contact_people

  has_many :contact_person_offers, inverse_of: :contact_person
  has_many :offers, through: :contact_person_offers

  # Validations
  validates :organization_id, presence: true
  validates :at_least_one_field_present

  def at_least_one_field_present
    if %w(name telephone email).all? { |field| self[field].blank? }
      errors.add :base, 'Yo, not cool dude'
    end
  end

  # Methods
  delegate :name, to: :organization, prefix: true

  # For rails_admin display
  def display_name
    "##{id} #{name} (#{organization_name})"
  end
end
