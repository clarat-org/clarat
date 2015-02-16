# Connector Model for Organization's parent-child relationship
# as some are umbrella organizations to multiple others and some even have
# multiple umbrellas
class OrganizationConnection < ActiveRecord::Base
  # Associations
  belongs_to :parent, class_name: 'Organization', inverse_of: :children
  belongs_to :child, class_name: 'Organization', inverse_of: :parents

  # Validations
  validates :parent_id, presence: true
  validates :child_id, presence: true
end
