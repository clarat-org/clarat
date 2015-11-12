require_relative '../test_helper'

describe CategoriesController do
  describe "GET 'index'" do
    it 'should respond to json requests for an offer' do
      # sign_in FactoryGirl.create :researcher
      get :index, locale: 'de', format: :json, offer_name: 'bla'
      assert_response :success
    end
  end
end
