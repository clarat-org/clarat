class Category < ActiveRecord::Base
  # AwesomeNestedSet
  acts_as_nested_set counter_cache: :children_count, depth_column: :depth

  # associtations
  has_and_belongs_to_many :dependent_categories,
                          class_name: 'Category',
                          join_table: 'dependent_categories',
                          foreign_key: 'category_id',
                          association_foreign_key: 'dependent_id'
  has_and_belongs_to_many :offers
  has_many :organizations, through: :offers

  # Validations
  validates :name, uniqueness: true, presence: true
  validates :synonyms, length: { maximum: 400 }

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
