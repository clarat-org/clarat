# Monkeypatch clarat_base Category
require ClaratBase::Engine.root.join('app', 'models', 'category')

class Category < ActiveRecord::Base
  # Methods

  # cached hash_tree, prepared for use in offers#index
  # TODO: do this differently!
  def self.sorted_hash_tree section_filter_identifier = 'family'
    # find every category that is not in the current section
    section_filter = SectionFilter.find_by identifier: section_filter_identifier

    # invalid_categories =
    #   Category.joins(:section_filters)
    #     .where('section_filters.identifier != ?', section_filter_identifier)

    invalid_categories = []
    Category.all.find_each do |category|
      next if category.section_filters.include? section_filter
      invalid_categories << category
    end

    Rails.cache.fetch "sorted_hash_tree_#{section_filter_identifier}" do
      current_tree = hash_tree
      # remove all invalid (without current section filter) categories
      invalid_categories.each do |invalid_category|
        current_tree = current_tree.deep_reject_key!(invalid_category)
      end
      current_tree.sort_by { |tree| tree.first.icon || '' }
    end
  end
end
