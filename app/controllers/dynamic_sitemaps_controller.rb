# frozen_string_literal: true
# Monkey Patch dynamic_sitemaps to prevent auth
class DynamicSitemapsController < ApplicationController
  def sitemap
    sitemap = ::Sitemap.find_by(path: request.path[1..-1])

    if sitemap
      render text: sitemap.content
    else
      goto_404
    end
  end
end
