# frozen_string_literal: true

class SearchFormRefinery < ApplicationRefinery
  def root
    'search_form'
  end

  def default
    %i[
      query generated_geolocation search_location language
      exact_location contact_type target_audience exclusive_gender
      residency_status
    ]
  end
end
