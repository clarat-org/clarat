class SearchLocationsController < ApplicationController
  skip_before_action :authenticate_user!
  respond_to :json

  def show
    requested_location = Sanitize.clean(params[:id])
    @search_location = SearchLocation.find_or_generate requested_location
    authorize @search_location
    respond_with @search_location
  end
end
