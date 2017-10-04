# frozen_string_literal: true

require_relative '../test_helper'

describe PagesController do
  describe "GET 'home'" do
    it 'should work' do
      get :home, params: { locale: 'de', section: 'family' }
      assert_response :success
    end

    it 'should use a a correct canonical URL' do
      get :home, params: { locale: 'de', section: 'family' }
      assert_includes response.body, 'http://test.host/family'
    end
  end

  describe "GET 'about'" do
    it 'should work' do
      get :about, params: { locale: 'de', section: 'refugees' }
      assert_response :success
    end
  end

  describe "GET 'faq'" do
    it 'should work' do
      get :faq, params: { locale: 'de', section: 'family' }
      assert_response :success
    end
  end

  describe "GET 'impressum'" do
    it 'should work' do
      get :impressum, params: { locale: 'de', section: 'refugees' }
      assert_response :success
    end
  end

  describe "GET 'agb'" do
    it 'should work' do
      get :agb, params: { locale: 'de', section: 'family' }
      assert_response :success
    end
  end

  describe "GET 'privacy'" do
    it 'should work' do
      get :privacy, params: { locale: 'de', section: 'refugees' }
      assert_response :success
    end
  end

  describe "GET 'widget-start-with-a-friend'" do
    it 'should work' do
      get :widget_swaf, params: { locale: 'de', section: 'refugees' }
      assert_response :success
    end
  end

  describe "GET 'widget-handbook-germany-berlin'" do
    it 'should work' do
      get :widget_hg, params: { locale: 'de', section: 'refugees', city: 'hamburg' }
      assert_response :success
    end
  end

  describe "GET 'widget-handbook-germany-hamburg'" do
    it 'should work' do
      get :widget_hg, params: { locale: 'de', section: 'refugees', city: 'hamburg' }
      assert_response :success
    end
  end

  describe "GET 'widget-handbook-germany-muenchen'" do
    it 'should work' do
      get :widget_hg, params: { locale: 'de', section: 'refugees', city: 'muenchen' }
      assert_response :success
    end
  end

  describe "GET 'widget-handbook-germany-dortmund'" do
    it 'should work' do
      get :widget_hg, params: { locale: 'de', section: 'refugees', city: 'dortmund' }
      assert_response :success
    end
  end

  describe "GET 'not_found'" do
    it 'should work' do
      get :not_found, params: { locale: 'de' }
      assert_template 'not_found'
      assert_response 404
    end
  end

  describe "GET 'section_forward'" do
    it 'should redirect to the default section' do
      ActionDispatch::Request.any_instance.expects(:fullpath)
                             .returns('/somepath#someanchor').twice
      get :section_forward, params: { locale: 'de' }
      assert_redirected_to '/refugees/somepath#someanchor'
    end

    it 'should redirect correctly for the default root path' do
      ActionDispatch::Request.any_instance.stubs(:fullpath)
                             .returns('/')
      get :section_forward, params: { locale: 'de' }
      assert_redirected_to '/refugees/'
    end

    it 'should redirect correctly for a translated root path' do
      ActionDispatch::Request.any_instance.stubs(:fullpath)
                             .returns('/en')
      get :section_forward, params: { locale: 'en' }
      assert_redirected_to '/en/refugees'
    end

    it 'should redirect correctly for a translated page' do
      ActionDispatch::Request.any_instance.stubs(:fullpath)
                             .returns('/en/about-us')
      get :section_forward, params: { locale: 'en' }
      assert_redirected_to '/en/refugees/about-us'
    end
  end
end
