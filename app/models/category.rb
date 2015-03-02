class Category < ActiveRecord::Base
  # AwesomeNestedSet
  # acts_as_nested_set counter_cache: :children_count, depth_column: :depth
  has_closure_tree

  # associtations
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

  # alias for rails_admin_nestable
  singleton_class.send :alias_method, :arrange, :hash_tree

  # display name: main categories get an asterisk
  def name_with_optional_asterisk
    name + (icon ? '*' : '') if name
  end
end
