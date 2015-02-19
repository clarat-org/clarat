class SearchFormRefinery < ApplicationRefinery
  def root
    'search_form'
  end

  def default
    [
      :query, :generated_geolocation, :search_location, :categories
    ]
  end
end
