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

  # TODO: BEEEEEH! Wiedervorlage spätestens 1. Februar
  # auch im ApplicationController!

  def self.current_section= section
    @current_section = section
  end

  def self.current_section
    @current_section
  end

  def name
    original_name = super
    if original_name == 'Sorgen im Alltag' &&
       Category.current_section == 'refugees'
      return 'Leben in Deutschland'
    else
      original_name
    end
  end
  # /BEEEEEH
end
