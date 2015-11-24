# Newsletter Subscription Creation
class SubscriptionsController < ApplicationController
  respond_to :js
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    @subscription = Subscription.new
    respond_with @subscription
  end

  def create
    @subscription = Subscription.new params.for(Subscription).refine
    if @subscription.save
      render :create
    else
      render :new
    end
  end
end
