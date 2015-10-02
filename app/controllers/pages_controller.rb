# Static pages
class PagesController < ApplicationController
  def home
  end

  def about
    @names = %w(amina andrea anne basti elisa janina jens jule julia julian
                konstantin lisa marcus nicole stefan verena)
  end

  def faq
  end

  def impressum
  end

  def agb
  end

  def privacy
  end

  def not_found
    render status: 404, formats: [:html]
  end
end
