# Newsletter Subscription Creation
class SubscriptionsController < ApplicationController
  respond_to :js
  skip_before_action :verify_authenticity_token, only: :create

  def new
    @subscription = Subscription.new
    respond_with @subscription
  end

  def create
    @subscription = Subscription.new params.for(Subscription).refine
    if @subscription.save
      render :create
      # redirect_to root_path, flash: { success: t('.success') }
    else
      render :new
      # redirect_to root_path, flash: { error: t('.error') }
    end
  end
end
