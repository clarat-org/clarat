# TODO: schedule
host 'www.clarat.org'

sitemap :site do
  url section_choice_url,
      last_mod: Time.zone.now, change_freq: 'daily', priority: 1.0

  I18n.available_locales.each do |locale|
    url send(:"offers_#{locale}_url", section: :refugees), priority: 0.6
    url send(:"offers_#{locale}_url", section: :family), priority: 0.6

    url send(:"about_#{locale}_url", section: :refugees), priority: 0.5
    url send(:"faq_#{locale}_url", section: :refugees), priority: 0.5

    url send(:"new_contact_#{locale}_url", section: :refugees), priority: 0.4
  end

  url impressum_url(section: :refugees), priority: 0.1
  url agb_url(section: :refugees), priority: 0.1
  url privacy_url(section: :refugees), priority: 0.1
end

# You can have multiple sitemaps like the above - just make sure their names are different.

# Automatically link to all pages using the routes specified
# using "resources :pages" in config/routes.rb. This will also
# automatically set <lastmod> to the date and time in page.updated_at:
#
#   sitemap_for Page.scoped

sitemap_for Offer.approved do |offer|
  I18n.available_locales.each do |locale|
    url send(:"offer_#{locale}_url", offer.canonical_section, offer),
        last_mod: offer.updated_at, priority: 0.9
  end
end

sitemap_for Organization.approved do |orga|
  I18n.available_locales.each do |locale|
    url send(:"organization_#{locale}_url", orga.canonical_section, orga),
        last_mod: orga.updated_at, priority: 0.8
  end
end

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
ping_with "http://#{host}/sitemaps/sitemap.xml"
