require_relative '../test_helper'

describe CategoriesController do
  describe "GET 'index'" do
    it 'should respond to json requests for an offer' do
      # sign_in FactoryGirl.create :researcher
      get :index, format: :json, offer_name: 'bla',
                  locale: 'de', section: 'family'
      assert_response :success
    end
  end
end
