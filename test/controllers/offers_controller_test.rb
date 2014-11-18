require_relative '../test_helper'

describe OffersController do
  describe "GET 'show'" do
    it "should work (with friendly id)" do
      offer = FactoryGirl.create :offer
      get :show, id: offer.slug, locale: 'de'
      assert_response :success
    end
  end
end
