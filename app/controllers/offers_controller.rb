class OffersController < ApplicationController
  include GmapsVariable
  respond_to :html

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :init_search_cache, only: [:index]

  rescue_from InvalidLocationError do |_error|
    render 'invalid_location', status: 404
  end

  # TODO: can you do this with plain routing?
  def index
    if request.xhr?
      index_xhr
    else
      @category_tree ||= Category.sorted_hash_tree
      set_position
      prepare_location_unavailable
      render :index
    end
  end

  # pseudo action, handler for when index is called via ajax
  def index_xhr
    get_and_assign_search_results_to_instance_variables
    prepare_gmaps_variables @personal_offers if @personal_offers
    render :index_xhr, layout: false
  end

  def show
    @offer = Offer.friendly.find(params[:id])
    authorize @offer

    prepare_gmaps_variable @offer
    @contact = Contact.new url: request.url, reporting: true
    respond_with @offer
  end

  private

  ### INDEX ###

  def page
    params[:page]
  end

  # general variable assignments: search for results, get categories, etc.
  def get_and_assign_search_results_to_instance_variables
    @personal_offers = search.personal_hits
    @remote_offers = search.remote_hits
    @facets = search.facets_hits
    @nearby = search.nearby_hits
  end

  # Warning: cannot be memoized
  # @search_cache is set in ApplicationController!?
  # work with instance variable instead
  def init_search_cache
    @search_cache = SearchForm.new(search_params)
  end

  def search_params
    params.for(SearchForm).refine
  end

  def search
    @search ||= SearchManager.new(@search_cache, page: page)
  end

  # Set geolocation variables to cookie
  def set_position
    @position = @search_cache.geolocation
    if @search_cache.search_location == I18n.t('conf.current_location')
      # erase cookie so that next time the current location will be used again
      cookies[:last_search_location] = nil
    else
      # set cookie so that next time the same location will be prefilled
      cookies[:last_search_location] = {
        value: @search_cache.location_for_cookie,
        expires: 3.months.from_now
      }
    end
  end

  # prepare an UpdateRequest that will be displayed if the user entered a search
  # that has no nearby_hits
  def prepare_location_unavailable
    @update_request = UpdateRequest.new(
      search_location: @search_cache.search_location
    )
  end

  ### /INDEX ###
end
