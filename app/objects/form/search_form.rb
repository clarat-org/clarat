class SearchForm
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  # def persisted?
  #   false
  # end

  attribute :query, String

  def search page
    Offer.search query, hitsPerPage: 5
  end
end