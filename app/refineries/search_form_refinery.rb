class SearchFormRefinery < ApplicationRefinery
  def root
    false
  end

  def default
    [
      :query
    ]
  end
end
