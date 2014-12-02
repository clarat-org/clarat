class TagsController < ApplicationController
  respond_to :json

  def index
    offer_tags = Offer.where(name: params[:offer_name]).
                       joins(:tags).pluck('DISTINCT(tags.name)')

    respond_with offer_tags
  end
end
