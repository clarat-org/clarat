# frozen_string_literal: true
require_relative '../test_helper'

describe SubscriptionsController do
  describe "GET 'new'" do
    it 'should work' do
      xhr :get, :new, params: { locale: 'de' }
      assert_response :success
      assert_template :new
    end
  end

  describe "POST 'create'" do
    it 'should work with valid email' do
      attrs = FactoryGirl.attributes_for :subscription
      assert_difference('Subscription.count', 1) do
        post :create, params: { locale: 'de', format: :js, subscription: attrs }
      end
      assert_template :create
      # assert_redirected_to :root
    end

    it 'should not work with invalid email' do
      assert_difference('Subscription.count', 0) do
        post :create, params: { locale: 'de', format: :js,
                      subscription: { email: 'not a mail' }
                    }
      end
      assert_template :new
      # assert_redirected_to :root
    end
  end
end
