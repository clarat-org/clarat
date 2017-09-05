# frozen_string_literal: true
require_relative '../test_helper'

describe DynamicSitemapsController do
  let(:sitemap) { Sitemap.create path: 'sitemaps/site.xml', content: 'foo' }

  it 'must work' do
    request.stubs(:path).returns('/sitemaps/site.xml')
    get :sitemap, params: { sitemaps: sitemap.path, use_route: 'sitemaps' }
    assert_response :success
    response.body.must_equal 'foo'
  end

  it 'wont work without sitemap' do
    get :sitemap, params: { sitemaps: 'doesntexist', use_route: 'sitemaps' }
    assert_redirected_to '/404'
  end
end
