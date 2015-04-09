class CategoriesController < ApplicationController
  respond_to :json

  # For admin backend: Provides a list of categories that offers with name X
  # already belong to.
  def index
    offer_categories = Offer.where(name: params[:offer_name])
                       .joins(:categories).pluck('DISTINCT(categories.name)')

    respond_with offer_categories
  end
end
