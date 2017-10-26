# frozen_string_literal: true

# Monkey Patch dynamic_sitemaps to prevent auth
class DynamicSitemapsController < ApplicationController
  def sitemap
    # binding.pry
    # puts '+++++ ' + request.url
    sitemap = ::Sitemap.find_by(path: request.path[1..-1])
    raise ActiveRecord::RecordNotFound unless sitemap
    render plain: sitemap.content
  end
end
