require_relative '../test_helper'
describe PreviewsController do
  describe "GET 'show_offer'" do
    before do
      @offer = FactoryGirl.create :offer, name: 'bazfuz'
    end

    it 'should show an unapproved offer with correct http auth' do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Basic.encode_credentials(
          'test', 'test'
        )

      get :show_offer, id: @offer.slug, locale: 'de',
                       section: @offer.section.identifier
      assert_response :success
      assert_select 'title', 'bazfuz | clarat'
    end

    it 'should not allow access without http auth' do
      get :show_offer, id: @offer.slug, locale: 'de', section: 'refugees'
      assert_response 401
    end
  end

  describe "GET 'show_organization'" do
    before do
      @orga = FactoryGirl.create :organization, name: 'bazfuz'
    end

    it 'should show an unapproved organization with correct http auth' do
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Basic.encode_credentials(
          'test', 'test'
        )

      get :show_organization, id: @orga.slug, locale: 'de', section: 'refugees'
      assert_response :success
      assert_select 'title', 'bazfuz | clarat'
    end

    it 'should not allow access without http auth' do
      get :show_organization, id: @orga.slug, locale: 'de', section: 'family'
      assert_response 401
    end
  end
end
