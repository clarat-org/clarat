require_relative '../test_helper'

describe UpdateRequestsController do
  describe "GET 'new'" do
    it 'should work' do
      xhr :get, :new, locale: 'de'
      assert_response :success
      assert_template :new
    end
  end

  describe "POST 'create'" do
    it 'should work with valid email' do
      attrs = FactoryGirl.attributes_for :update_request
      assert_difference('UpdateRequest.count', 1) do
        post :create, locale: 'de', format: :js, update_request: attrs
      end
      assert_template :create
    end

    it 'should not work with invalid email' do
      assert_difference('UpdateRequest.count', 0) do
        post :create, locale: 'de', format: :js,
                      update_request: { email: 'not a mail' }
      end
      assert_template :new
    end
  end
end
