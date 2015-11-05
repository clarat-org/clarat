require_relative '../test_helper'

describe OffersController do
  describe "GET 'show'" do
    describe 'for an approved offer' do
      it 'should work (with friendly id)' do
        offer = FactoryGirl.create :offer, :approved, name: 'bazfuz',
                                                      section: 'family'
        get :show, id: offer.slug, locale: 'de', section: 'family'
        assert_response :success
        assert_select 'title', 'bazfuz | clarat'
      end

      it 'should use the correct canonical URL' do
        offer = FactoryGirl.create :offer, :approved, section: 'family'
        get :show, id: offer.slug, locale: 'de', section: 'family'
        canonical_link = css_select('link[rel=canonical]').first
        assert_equal canonical_link.attributes['href'],
                     "http://test.host/family/angebote/#{offer.slug}"
      end

      it 'should redirect if the wrong section was given' do
        offer = FactoryGirl.create :offer, :approved, section: 'refugees'
        get :show, id: offer.slug, locale: 'de', section: 'family'
        assert_redirected_to section: 'refugees'
      end

      it 'shouldnt show on unapproved offer' do
        offer = FactoryGirl.create :offer
        get :show, id: offer.slug, locale: 'de', section: 'refugees'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end

      it 'should redirect to 404 if offer not found' do
        get :show, id: 'doesntexist', locale: 'de', section: 'family'
        assert_redirected_to controller: 'pages', action: 'not_found'
      end
    end
  end

  describe "GET 'index'" do
    it 'should work' do
      get :index, locale: 'de', section: 'refugees'
      assert_response :success
    end

    it 'should work with "my location"' do
      get :index, locale: 'de', section: 'family', search_form: {
        search_location: I18n.t('conf.current_location'),
        generated_geolocation: I18n.t('conf.default_latlng')
      }
      assert_response :success
    end
  end

  describe "GET 'section_forward'" do
    it 'should redirect to the default location if it has both sections' do
      offer = FactoryGirl.create :offer, :approved
      offer.section_filters = [filters(:family), filters(:refugees)]
      get :section_forward, id: offer.slug, locale: 'de'
      assert_redirected_to controller: 'offers', action: 'show',
                           section: SectionFilter::DEFAULT
    end

    it 'should redirect to the family section if it has only that one' do
      offer = FactoryGirl.create :offer, :approved, section: 'family'
      get :section_forward, id: offer.slug, locale: 'de'
      assert_redirected_to controller: 'offers', action: 'show',
                           section: 'family'
    end

    it 'should redirect to the refugees section if it has only that one' do
      offer = FactoryGirl.create :offer, :approved, section: 'refugees'
      get :section_forward, id: offer.slug, locale: 'de'
      assert_redirected_to controller: 'offers', action: 'show',
                           section: 'refugees'
    end
  end
end
