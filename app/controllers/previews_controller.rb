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
    model_instance = model_instance model_type, params[:id]
    instance_variable_set "@#{model_type}", model_instance
    initialize_markers
    prepare_gmaps_variable model_instance
    @contact = Contact.new url: request.url, reporting: true
    render "/#{model_type}s/show"
  end

  def model_instance model_type, model_id
    if model_type.classify == 'Offer'
       model_type.classify.constantize.in_section(@current_section).friendly
         .find(model_id)
     else
       model_type.classify.constantize.friendly.find(model_id)
     end
  end
end
