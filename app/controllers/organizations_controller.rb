class OrganizationsController < ApplicationController
  include GmapsVariable
  respond_to :html

  skip_before_action :authenticate_user!, only: [:show]

  def show
    @organization = Organization.friendly.find(params[:id])
    authorize @organization
    prepare_gmaps_variable @organization
    respond_with @organization
  end
end
