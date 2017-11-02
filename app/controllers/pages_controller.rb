# frozen_string_literal: true

# Static pages
class PagesController < ApplicationController
  def section_choice; end

  def home; end

  def about
    @names = %w[andrea anna anne astrid basti bettina birte chrissy claudia
                damjan eleonore elisa esther fabian hassan jakob janina janina_m
                jenny jule julia_b julia juliane karo katja konstantin laura_i
                laura_w line magdalena michaela nahla nathalie nicole nils omar
                sabine sophie stefan tian tine verena]
  end

  def faq; end

  def impressum; end

  def agb; end

  def privacy; end

  def not_found
    render status: 404, formats: [:html]
  end

  def widget_swaf
    render layout: 'widget'
  end

  def widget_hg
    render layout: 'widget'
  end

  def section_forward
    split_path = request.fullpath.split('/', -1)
    insertion_index = split_path.last == params['locale'] ? -1 : -2
    forward_path =
      split_path.insert(insertion_index, Section::DEFAULT).join('/')
    redirect_to forward_path
  end
end
