class SearchFormRefinery < ApplicationRefinery
  def root
    'search_form'
  end

  def default
    [
      :query, :generated_geolocation, :search_location, :category,
      :exact_location, :contact_type,
      :age, :target_audience, :exclusive_gender, :language
    ]
  end
end
