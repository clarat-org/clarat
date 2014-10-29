class OrganizationsController < ApplicationController
  # What is this all about?
  respond_to :html

  skip_before_action :authenticate_user!, only: [:show]

  def show
    @organization = Organization.friendly.find(params[:id])
    @location = Location.where(
                  organization_id: @organization.id, hq: true).first
    authorize @organization
    respond_with @organization
  end
end