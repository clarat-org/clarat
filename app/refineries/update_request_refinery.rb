class UpdateRequestRefinery < ApplicationRefinery
  def create
    [
      :search_location, :email
    ]
  end
end
