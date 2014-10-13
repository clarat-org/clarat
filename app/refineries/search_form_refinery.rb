class SearchFormRefinery < ApplicationRefinery
  def root
    false
  end

  def default
    [
      :query, :geoloc
    ]
  end
end
