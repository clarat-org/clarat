# frozen_string_literal: true
# "Send me an update when you have offers in my city" Request Form
class UpdateRequestsController < ApplicationController
  respond_to :js

  def new
    @update_request = UpdateRequest.new
    respond_with @update_request
  end

  def create
    @update_request = UpdateRequest.new update_request_params
    if @update_request.save
      render :create, layout: 'modal_create.js.erb',
                      content_type: 'text/javascript'
    else
      render :new
    end
  end

  private

  def update_request_params
    params.require(:update_request).permit(:search_location, :email)
  end
end
