# frozen_string_literal: true

# Newsletter Subscription Creation
class SubscriptionsController < ApplicationController
  respond_to :js

  def new
    @subscription = Subscription.new
    respond_with @subscription
  end

  def create
    @subscription = Subscription.new subscription_params
    if @subscription.save
      render :create
    else
      render :new
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email)
  end
end
