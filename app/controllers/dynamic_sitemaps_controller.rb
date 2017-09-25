# frozen_string_literal: true
# Monkey Patch dynamic_sitemaps to prevent auth
class DynamicSitemapsController < ApplicationController
  def sitemap
    sitemap = ::Sitemap.find_by_path(request.path[1..-1])
    return redirect_to '/404' unless sitemap
    render plain: sitemap.content
  end
end
