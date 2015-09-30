class OrganizationsController < ApplicationController
  include GmapsVariable
  respond_to :html

  def show
    @organization = Organization.friendly.find(params[:id])
    password_protect unless @organization.approved?
    prepare_gmaps_variable @organization
    @contact = Contact.new url: request.url, reporting: true
    respond_with @organization
  end
end
