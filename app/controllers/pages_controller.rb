# Static pages
class PagesController < ApplicationController
  def section_choice
  end

  def home
  end

  def about
    @names = %w(amina andrea anja ann-sophie anna anne astrid basti bettina
                birte chrissy claudia damjan eleonore elisa esther fabian hassan
                jakob janina janina_m jenny jens jule julia_b julia juliane karo
                katja konstantin laura_i laura_w line lisa magdalena marie
                michaela nahla nathalie nils omar patrick philipp sabine sophie
                stefan tine verena)
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
