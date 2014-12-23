require_relative '../test_helper'

describe OffersController do
  describe "GET 'show'" do
    it 'should work (with friendly id)' do
      offer = FactoryGirl.create :offer, :approved
      get :show, id: offer.slug, locale: 'de'
      assert_response :success
    end

    it 'shouldnt allow on unapproved offer' do
      offer = FactoryGirl.create :offer
      assert_raises Pundit::NotAuthorizedError do
        get :show, id: offer.slug, locale: 'de'
      end
    end
  end
end
