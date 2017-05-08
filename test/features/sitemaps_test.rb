# frozen_string_literal: true
require_relative '../test_helper'

feature 'dynamic_sitemaps' do
  scenario 'gets generated and is displayable' do
    DynamicSitemaps.generate_sitemap

    visit dynamic_sitemaps_path + '/sitemap.xml'

    page.must_have_content 'site.xml'
    page.must_have_content 'offers.xml'
    page.must_have_content 'organizations.xml'
  end
end
