class OffersController < ApplicationController
  include GmapsVariable
  respond_to :html

  before_action :init_search_form, only: [:index]
  before_action :disable_caching, only: :index

  rescue_from InvalidLocationError do |_error|
    render 'invalid_location', status: 404
  end

  def index
    @category_tree ||= Category.sorted_hash_tree
    prepare_location_unavailable
    render :index
  end

  def show
    @offer = Offer.friendly.find(params[:id])
    self.class.password_protect unless @offer.approved?

    prepare_gmaps_variable @offer
    @contact = Contact.new url: request.url, reporting: true
    respond_with @offer
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

  # prepare an UpdateRequest that will be displayed if the user entered a search
  # that has no nearby_hits
  def prepare_location_unavailable
    @update_request = UpdateRequest.new(
      search_location: @search_form.search_location # TODO: set by JS
    )
  end

  ### /INDEX ###
end
