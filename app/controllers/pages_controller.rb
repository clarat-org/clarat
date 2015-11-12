# Static pages
class PagesController < ApplicationController
  def home
  end

  def about
    @names = %w(amina andrea anne astrid basti bettina elisa franzi janina janne
                jens jule julia julian katinka konstantin laura lavinia line
                lisa marcus nicole nils stefan tine verena)
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
