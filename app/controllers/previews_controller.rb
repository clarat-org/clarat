# Shows previews for non-approved offers and organizations
class PreviewsController < ApplicationController
  # Needs auth - the main reason this is in a separate controller
  http_basic_authenticate_with(
    name: Rails.application.secrets.protect['user'],
    password: Rails.application.secrets.protect['pwd']
  )

  include GmapsVariable
  respond_to :html

  def show_offer
    show 'offer'
  end

  def show_organization
    show 'organization'
  end

  private

  def show model_type
    model_instance = model_type.classify.constantize.friendly.find(params[:id])

    instance_variable_set "@#{model_type}", model_instance
    initialize_markers
    prepare_gmaps_variable model_instance
    @contact = Contact.new url: request.url, reporting: true
    preferred_section model_instance
    render "/#{model_type}s/show"
  end

  # set section directly if it is distinct
  def preferred_section model_instance
    case @current_section
    when model_instance.class.name == "Offer"
      model_instance.section_filter.identifier
    when model_instance.section_filters.count >= 1
      model_instance.section_filters.first.identifier
    else
      nil #display nothing if there are no section_filters
    end
  end
end
