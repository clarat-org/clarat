class OffersController < ApplicationController
  respond_to :html

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @offers = build_search_cache.search params[:page]
    @tags = @search_cache.tags_by_facet
    set_position
    set_gmaps_variable
    respond_with @offers
  end

  def show
    @offer = Offer.friendly.find(params[:id])
    authorize @offer

    respond_with @offer
  end

  private

    def build_search_cache
      search_params = {}
      form_search_params = params.for(SearchForm)[:search_form]
      search_params.merge!(form_search_params) if form_search_params.is_a?(Hash)
      @search_cache = SearchForm.new(search_params)
    end

    def set_position
      @position = @search_cache.geolocation
      cookies[:last_geolocation] = @position.to_s
    end

    def set_gmaps_variable
      @markers = {}
      @offers.each do |offer|
        next unless offer.location
        key = Geolocation.new(offer.location)

        if @markers[key.to_s]
          @markers[key.to_s][:offer_ids] << offer.id
        else
          @markers[key.to_s] = {
            position: key.to_h,
            offer_ids: [offer.id]
          }
        end
      end
    end
end
