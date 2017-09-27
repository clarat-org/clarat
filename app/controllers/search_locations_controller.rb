# frozen_string_literal: true

# Microservice that allows front-end JS to convert a location to coordinates.
# Request capped via Rack::Attack to prevent external abuse.
class SearchLocationsController < ApplicationController
  respond_to :json

  def show
    requested_location = Sanitize.clean(params[:id])
    @search_location = SearchLocation.find_or_generate requested_location
    respond_with @search_location
  end
end
