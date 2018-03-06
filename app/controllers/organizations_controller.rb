# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include GmapsVariable
  respond_to :html

  def show
    @organization = Organization.visible_in_frontend.friendly.find_by(
      slug: params[:id]
    )
    raise ActiveRecord::RecordNotFound unless @organization
    unless @organization.in_section? @current_section
      return redirect_to section: @organization.canonical_section
    end
    prepare_gmaps_variable @organization
    @contact = Contact.new url: request.url, reporting: true
    respond_with @organization
  end

  def section_forward
    orga = Organization.visible_in_frontend.friendly.find(params[:id])
    orga_section = orga.canonical_section
    raise ActiveRecord::RecordNotFound unless orga_section
    # redirect_to organization_path(section: orga_section, id: orga.slug)
    route_name = t('routes.organizations', locale: params['locale'])
    locale_string = params['locale'].to_s == 'de' ? '' : "/#{params['locale']}"
    redirect_to "#{locale_string}/#{orga_section}/#{route_name}/#{orga.slug}", status: 301
  end
end
