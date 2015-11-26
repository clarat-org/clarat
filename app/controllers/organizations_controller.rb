class OrganizationsController < ApplicationController
  include GmapsVariable
  respond_to :html

  def show
    @organization = Organization.approved.friendly.find(params[:id])
    unless @organization.in_section? @current_section
      return redirect_to section: @organization.canonical_section
    end
    prepare_gmaps_variable @organization
    @contact = Contact.new url: request.url, reporting: true
    respond_with @organization
  end

  def section_forward
    orga = Organization.approved.friendly.find(params[:id])
    orga_section = orga.canonical_section
    return redirect_to '/404' unless orga_section
    redirect_to organization_path(section: orga_section, id: orga.slug)
  end
end
