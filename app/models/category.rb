# frozen_string_literal: true
# Monkeypatch clarat_base Category
require ClaratBase::Engine.root.join('app', 'models', 'category')

class Category < ActiveRecord::Base
  # Methods

  # Does this category or any of its decendants have offers? Needed to
  # determine if it shoul be shown in the search results
  def offers_in_section? section
    self_and_descendants.any? do |category|
      category.offers.visible_in_frontend.in_section(section).any?
    end
  end
end
