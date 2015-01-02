class SubscriptionRefinery < ApplicationRefinery
  def create
    [ :email ]
  end
end
