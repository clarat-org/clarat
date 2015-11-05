require_relative '../test_helper'

describe PagesController do
  describe "GET 'home'" do
    it 'should work' do
      get :home, locale: 'de', section: 'family'
      assert_response :success
    end

    it 'should use a a correct canonical URL' do
      get :home, locale: 'de', section: 'family'
      canonical_link = css_select('link[rel=canonical]').first
      assert_equal canonical_link.attributes['href'],
                   'http://test.host/refugees'
    end
  end

  describe "GET 'about'" do
    it 'should work' do
      get :about, locale: 'de', section: 'refugees'
      assert_response :success
    end
  end

  describe "GET 'faq'" do
    it 'should work' do
      get :faq, locale: 'de', section: 'family'
      assert_response :success
    end
  end

  describe "GET 'impressum'" do
    it 'should work' do
      get :impressum, locale: 'de', section: 'refugees'
      assert_response :success
    end
  end

  describe "GET 'agb'" do
    it 'should work' do
      get :agb, locale: 'de', section: 'family'
      assert_response :success
    end
  end

  describe "GET 'privacy'" do
    it 'should work' do
      get :privacy, locale: 'de', section: 'refugees'
      assert_response :success
    end
  end

  describe "GET 'not_found'" do
    it 'should work' do
      get :not_found, locale: 'de'
      assert_template 'not_found'
      assert_response 404
    end
  end

  describe "GET 'section_forward'" do
    it 'should redirect to the default section' do
      ActionDispatch::Request.any_instance.expects(:fullpath)
        .returns('/somepath#someanchor').twice
      get :section_forward, locale: 'de'
      assert_redirected_to '/refugees/somepath#someanchor'
    end
  end
end
