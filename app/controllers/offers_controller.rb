class OffersController < ApplicationController
  respond_to :html

  skip_before_action :authenticate_user!, only: [:index]

  def index
    @offers = build_search_cache.search params[:page]
    respond_with @offers
  end

  def show
    @offer = Offer.find(params[:id])
    respond_with @offer
  end

  private

    def build_search_cache
      search_params = {}
      form_search_params = params.for(SearchForm)[:search_form]
      search_params.merge!(form_search_params) if form_search_params.is_a?(Hash)
      @search_cache = SearchForm.new(search_params)
    end
end
