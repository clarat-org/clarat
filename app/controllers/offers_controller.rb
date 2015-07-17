class OffersController < ApplicationController
  include GmapsVariable
  respond_to :html

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :init_search_form, only: [:index]

  rescue_from InvalidLocationError do |_error|
    render 'invalid_location', status: 404
  end

  def index
    @category_tree ||= Category.sorted_hash_tree
    set_position
    prepare_location_unavailable
    render :index
  end

  def show
    @offer = Offer.friendly.find(params[:id])
    authorize @offer

    prepare_gmaps_variable @offer
    # @feedback = Feedback.new url: request.url, reporting: true
    form Feedback::Create
    # present Offer::Create
    # respond_with @offer
  end

  private

  ### INDEX ###

  # Warning: cannot be memoized
  # @search_form is set in ApplicationController!?
  # work with instance variable instead
  def init_search_form
    @search_form = SearchForm.new(search_params)
  end

  def search_params
    params.for(SearchForm).refine
  end

  # Set geolocation variables to cookie
  def set_position
    if @search_form.search_location == I18n.t('conf.current_location')
      # erase cookie so that next time the current location will be used again
      cookies[:last_search_location] = nil
    else
      # set cookie so that next time the same location will be prefilled
      cookies[:last_search_location] = {
        value: @search_form.location_for_cookie,
        expires: 3.months.from_now
      }
    end
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
