class CategoriesController < ApplicationController
  respond_to :json

  def index
    offer_categories = Offer.where(name: params[:offer_name])
                        .joins(:categories).pluck('DISTINCT(categories.name)')

    respond_with offer_categories
  end
end
