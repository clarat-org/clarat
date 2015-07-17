# TODO: schedule
host 'developer.clarat.org'

sitemap :site do
  url root_url, last_mod: Time.zone.now, change_freq: 'daily', priority: 1.0
  url about_url, priority: 0.5
  url faq_url, priority: 0.5
  url new_feedback_url, priority: 0.4
  url impressum_url, priority: 0.1
  url agb_url, priority: 0.1
  url privacy_url, priority: 0.1
end

# You can have multiple sitemaps like the above - just make sure their names are different.

# Automatically link to all pages using the routes specified
# using "resources :pages" in config/routes.rb. This will also
# automatically set <lastmod> to the date and time in page.updated_at:
#
#   sitemap_for Page.scoped

high_prio = proc do |record|
  url record, last_mod: record.updated_at, priority: 0.9
end

sitemap_for(Offer.approved, &high_prio)
sitemap_for(Organization.approved, &high_prio)

# For products with special sitemap name and priority, and link to comments:
#
#   sitemap_for Product.published, name: :published_products do |product|
#     url product, last_mod: product.updated_at, priority: (product.featured? ? 1.0 : 0.7)
#     url product_comments_url(product)
#   end

# If you want to generate multiple sitemaps in different folders (for example if you have
# more than one domain, you can specify a folder before the sitemap definitions:
#
#   Site.all.each do |site|
#     folder "sitemaps/#{site.domain}"
#     host site.domain
#
#     sitemap :site do
#       url root_url
#     end
#
#     sitemap_for site.products.scoped
#   end

# Ping search engines after sitemap generation:
#
#   ping_with "http://#{host}/sitemap.xml"
