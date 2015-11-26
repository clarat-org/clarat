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

  def in_section? section
    section_filters.where(identifier: section).count > 0
  end
end
