class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  def home
  end

  def about
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
    render status: 404
  end
end
