require_relative '../test_helper'

describe OffersController do
  describe "GET 'show'" do
    it 'should work (with friendly id)' do
      offer = FactoryGirl.create :offer, :approved, name: 'bazfuz'
      get :show, id: offer.slug, locale: 'de'
      assert_response :success
      assert_select 'title', 'bazfuz | clarat'
    end

    it 'shouldnt allow on unapproved offer' do
      offer = FactoryGirl.create :offer
      assert_raises Pundit::NotAuthorizedError do
        get :show, id: offer.slug, locale: 'de'
      end
    end

    it 'should redirect to 404 if offer not found' do
      get :show, id: 'doesntexist', locale: 'de'
      assert_redirected_to controller: 'pages', action: 'not_found'
    end
  end
end
