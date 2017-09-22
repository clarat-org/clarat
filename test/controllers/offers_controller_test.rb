# frozen_string_literal: true

require_relative '../test_helper'

describe OffersController do
  describe "GET 'show'" do
    describe 'for an approved offer' do
      it 'should work (with friendly id)' do
        offer = offers(:basic)
        offer.name = 'bazfuz'
        get :show, params: { id: offer.slug, locale: 'de', section: 'family' }
        assert_response :success
        assert_select 'title', 'basicOfferName | clarat'
      end

      it 'should use the correct canonical URL' do
        offer = offers(:basic)
        get :show, params: { id: offer.slug, locale: 'de', section: 'family' }
        assert_includes response.body,
                        "http://test.host/family/angebote/#{offer.slug}"
      end

      it 'shouldnt show on unapproved offer' do
        offer = offers(:basic)
        get :show, params: { id: offer.slug, locale: 'de', section: 'refugees' }
        assert_redirected_to controller: 'pages', action: 'not_found'
      end

      it 'should redirect to 404 if offer not found' do
        get :show, params: { id: 'doesntexist', locale: 'de', section: 'family' }
        assert_redirected_to controller: 'pages', action: 'not_found'
      end
    end

    describe 'for an expired offer' do
      it 'should work (with friendly id)' do
        offer = offers(:basic)
        offer.update_columns aasm_state: 'expired'
        get :show, params: { id: offer.slug, locale: 'de', section: 'family' }
        assert_response :success
        assert_select 'title', 'basicOfferName | clarat'
      end

      it 'should use the correct canonical URL' do
        offer = offers(:basic)
        offer.update_columns aasm_state: 'expired'
        get :show, params: { id: offer.slug, locale: 'de', section: 'family' }
        assert_includes response.body,
                        "http://test.host/family/angebote/#{offer.slug}"
      end
    end
  end

  describe "GET 'index'" do
    it 'should work' do
      get :index, params: { locale: 'de', section: 'refugees' }
      assert_response :success
    end

    it 'should work with "my location"' do
      get :index, params: { locale: 'de', section: 'family', search_form: {
        search_location: I18n.t('conf.current_location'),
        generated_geolocation: I18n.t('conf.default_latlng')
      } }
      assert_response :success
    end
  end

  describe "GET 'section_forward'" do
    it 'should redirect to the family section if it has only that one' do
      offer = offers(:basic)
      get :section_forward, params: { id: offer.slug, locale: 'de' }
      assert_redirected_to controller: 'offers', action: 'show',
                           section: 'family'
    end

    it 'should redirect to the refugees section if it has only that one' do
      offer = offers(:basic)
      offer.section = sections(:refugees)
      offer.save
      get :section_forward, params: { id: offer.slug, locale: 'de' }
      assert_redirected_to controller: 'offers', action: 'show',
                           section: 'refugees'
    end
  end
end
