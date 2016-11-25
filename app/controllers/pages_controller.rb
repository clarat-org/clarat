# Static pages
class PagesController < ApplicationController
  def section_choice
  end

  def home
  end

  def about
    @names = %w(amina andrea anja anna anne astrid basti bettina birte chrissy
                claudia eleonore elisa esther jakob janina janne jenny jens jule
                julia julian juliane karo katinka katja konstantin laura_i
                laura_w lavinia line lisa michaela nahla nathalie nicole nils
                philipp sabine stefan tine verena)
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
