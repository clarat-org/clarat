class Tag < ActiveRecord::Base
  # associtations
  has_and_belongs_to_many :dependent_tags,
                          class_name: 'Tag',
                          join_table: 'dependent_tags',
                          foreign_key: 'tag_id',
                          association_foreign_key: 'dependent_id'
  has_and_belongs_to_many :offers
  has_many :organizations, through: :offers

  # Validations
  validates :name, uniqueness: true, presence: true

  # Sanitization
  extend Sanitization
  auto_sanitize :name

  # Scope
  scope :mains, -> { where(main: true).order(:icon).limit(5) }

  # Methods

  def name_with_optional_asterisk
    name + (main ? '*' : '') if name
  end
end
