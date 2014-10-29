class OrganizationsController < ApplicationController
  # What is this all about?
  respond_to :html

  skip_before_action :authenticate_user!, only: [:show]

  def show
    @organization = Organization.friendly.find(params[:id])
    # debugger
    authorize @organization
    respond_with @organization
  end
end