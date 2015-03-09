class Category < ActiveRecord::Base
  # AwesomeNestedSet
  acts_as_nested_set counter_cache: :children_count, depth_column: :depth

  # associtations
  has_and_belongs_to_many :offers
  has_many :organizations, through: :offers

  # Validations
  validates :name, uniqueness: true, presence: true

  # Sanitization
  extend Sanitization
  auto_sanitize :name

  # Scope
  scope :mains, -> { where.not(icon: nil).order(:icon).limit(5) }

  # Methods

  def name_with_optional_asterisk
    name + (icon ? '*' : '') if name
  end
end
