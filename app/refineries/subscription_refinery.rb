# frozen_string_literal: true
class SubscriptionRefinery < ApplicationRefinery
  def create
    [:email]
  end
end
