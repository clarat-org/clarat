# Monkey Patch dynamic_sitemaps to prevent auth
class DynamicSitemapsController < ApplicationController
  skip_before_action :authenticate_user!

  def sitemap
    sitemap = ::Sitemap.find_by_path(request.path[1..-1])

    if sitemap
      render text: sitemap.content
    else
      goto_404
    end
  end
end
