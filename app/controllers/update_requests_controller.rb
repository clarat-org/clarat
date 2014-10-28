class UpdateRequestsController < ApplicationController
  skip_before_action :authenticate_user!
  respond_to :js

  def new
    @update_request = UpdateRequest.new
    authorize @update_request
    respond_with @update_request
  end

  def create
    @update_request = UpdateRequest.new params.for(UpdateRequest).refine
    authorize @update_request
    if @update_request.save
      render :create
    else
      render :new
    end
  end
end