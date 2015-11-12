# Newsletter Subscription Creation
class SubscriptionsController < ApplicationController
  skip_before_action :authenticate_user!
  respond_to :js

  def new
    @subscription = Subscription.new
    authorize @subscription
    respond_with @subscription
  end

  def create
    @subscription = Subscription.new params.for(Subscription).refine
    authorize @subscription
    if @subscription.save
      render :create
    else
      render :new
    end
  end
end
