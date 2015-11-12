require_relative '../test_helper'

describe OffersController do
  describe "GET 'show'" do
    describe 'for an approved offer' do
      it 'should work (with friendly id)' do
        offer = FactoryGirl.create :offer, :approved, name: 'bazfuz'
        get :show, id: offer.slug, locale: 'de'
        assert_response :success
        assert_select 'title', 'bazfuz | clarat'
      end

      it 'shouldnt show on unapproved offer' do
        offer = FactoryGirl.create :offer
        get :show, id: offer.slug, locale: 'de'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end

      it 'should redirect to 404 if offer not found' do
        get :show, id: 'doesntexist', locale: 'de'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end
    end
  end

  describe "GET 'index'" do
    it 'should work' do
      get :index, locale: 'de', search_form: { query: '' }
      assert_response :success
    end

    it 'should work with "my location"' do
      get :index, locale: 'de', search_form: {
        search_location: I18n.t('conf.current_location'),
        generated_geolocation: I18n.t('conf.default_latlng')
      }
      assert_response :success
    end
  end
end
