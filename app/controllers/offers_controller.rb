# frozen_string_literal: true

class OffersController < ApplicationController
  include GmapsVariable
  respond_to :html

  before_action :init_search_form, only: [:index]
  before_action :disable_caching, only: :index

  rescue_from 'InvalidLocationError' do |_error|
    render 'invalid_location', status: 404
  end

  def index
    prepare_location_unavailable
    render :index
  end

  def show
    @offer = Offer.in_section(@current_section)
                  .visible_in_frontend.friendly.find_by(slug: params[:id])
    raise ActiveRecord::RecordNotFound unless @offer
    prepare_gmaps_variable @offer
    @contact = Contact.new url: request.url, reporting: true
    respond_with @offer
  end

  def section_forward
    offer = Offer.visible_in_frontend.friendly.find(params[:id])
    offer_section = offer.canonical_section
    raise ActiveRecord::RecordNotFound unless offer_section
    route_name = t('routes.offers', locale: params['locale'])
    redirect_to "/#{params['locale']}/#{offer_section}/#{route_name}/#{offer.slug}", status: 301
  end

  private

  ### INDEX ###

  # Warning: cannot be memoized
  # @search_form is set in ApplicationController!?
  # work with instance variable instead
  def init_search_form
    @search_form = SearchForm.new(cookies, search_params)
  end

  def search_params
    return nil unless params['search_form']
    search_form_params
  end

  def search_form_params
    params.require(:search_form).permit(:query,
                                        :generated_geolocation,
                                        :search_location,
                                        :category,
                                        :exact_location,
                                        :contact_type,
                                        :encounters,
                                        :age,
                                        :target_audience,
                                        :exclusive_gender,
                                        :language)
  end

  # prepare an UpdateRequest that will be displayed if the user entered a search
  # that has no nearby_hits
  def prepare_location_unavailable
    @update_request = UpdateRequest.new(
      search_location: @search_form.search_location # TODO: set by JS
    )
  end

  ### /INDEX ###
end
