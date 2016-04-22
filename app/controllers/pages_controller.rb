# Static pages
class PagesController < ApplicationController
  def home
  end

  def about
    @names = %w(amina andrea anne astrid basti bettina elisa franziska janina
                janne jens jule julia julian katinka konstantin laura lavinia
                line lisa marcus nicole nils stefan tine verena)
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

  def section_forward
    split_path = request.fullpath.split('/', -1)
    insertion_index = split_path.last == params['locale'] ? -1 : -2
    forward_path =
      split_path.insert(insertion_index, SectionFilter::DEFAULT).join('/')
    redirect_to forward_path
  end
end
