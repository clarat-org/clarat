class ContactRefinery < ApplicationRefinery
  def default
    [
      :email, :name, :message, :city, :url, :reporting
    ]
  end
end
