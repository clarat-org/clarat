# Monkeypatch clarat_base Category
require ClaratBase::Engine.root.join('app', 'models', 'category')

class Category < ActiveRecord::Base
  # Methods

  # cached hash_tree, prepared for use in offers#index
  # TODO: do this differently!
  def self.sorted_hash_tree
    Rails.cache.fetch 'sorted_hash_tree' do
      hash_tree.sort_by { |tree| tree.first.icon || '' }
    end
  end

  # Does this category or any of its decendants have offers? Needed to
  # determine if it shoul be shown in the search results
  def offers_in_section? section
    self_and_descendants.any? do |category|
      category.offers.approved.in_section(section).any?
    end
  end
end
