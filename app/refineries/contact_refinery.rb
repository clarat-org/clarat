class ContactRefinery < ApplicationRefinery
  def default
    [
      :email, :name, :message, :url
    ]
  end
end
