# Monkey Patch dynamic_sitemaps to prevent auth
class DynamicSitemapsController < ApplicationController
  skip_before_action :authenticate_user!

  def sitemap
    sitemap = ::Sitemap.where(path: request.path[9..-1]).first

    if sitemap
      render text: sitemap.content
    else
      not_found
    end
  end

  protected
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
