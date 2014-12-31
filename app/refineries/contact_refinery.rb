class ContactRefinery < ApplicationRefinery
  def default
    [
      :email, :name, :message, :url, :reporting
    ]
  end
end
