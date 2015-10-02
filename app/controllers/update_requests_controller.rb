# "Send me an update when you have offers in my city" Request Form
class UpdateRequestsController < ApplicationController
  respond_to :js

  def new
    @update_request = UpdateRequest.new
    respond_with @update_request
  end

  def create
    @update_request = UpdateRequest.new params.for(UpdateRequest).refine
    if @update_request.save
      render :create, layout: 'modal_create.js.erb',
                      content_type: 'text/javascript'
    else
      render :new
    end
  end
end
