class OffersController < ApplicationController
  respond_to :html

  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @offers = build_search_cache.search params[:page]
    @tags = @search_cache.tags_by_facet
    test_location_unavailable
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
      if @search_cache.search_location == I18n.t('conf.current_location')
        cookies[:last_search_location] = nil # erase cookie so that next time the current location will be used again
      else
        cookies[:last_search_location] = @search_cache.search_location # set cookie so that next time the same location will be prefilled
      end
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

    # See if area is covered and if not instantiate an UpdateRequest
    def test_location_unavailable
      unless @search_cache.has_nearby?
        @update_request = UpdateRequest.new(
          search_location: @search_cache.search_location
        )
      end
    end
end
