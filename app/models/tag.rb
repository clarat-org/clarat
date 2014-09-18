class Tag < ActiveRecord::Base
  # associtations
  has_and_belongs_to_many :associated_tags,
    class_name: 'Tag',
    join_table: 'associated_tags',
    foreign_key: 'tag_id',
    association_foreign_key: 'associated_id'
  has_and_belongs_to_many :offers
  has_many :organizations, through: :offers

  # Validations
  validates :name, uniqueness: true, presence: true

  # Methods

  def name_with_optional_asterisk
    name + (main ? '*' : '')
  end
end
