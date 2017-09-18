# frozen_string_literal: true
require_relative '../test_helper'

describe ContactsController do
  describe "GET 'new'" do
    it 'should work' do
      get :new, locale: 'de', section: 'family'
      assert_response :success
      assert_template :new
    end
  end

  describe "POST 'create'" do
    it 'should work with valid contact data' do
      contact_attrs = FactoryGirl.attributes_for :contact
      request.env['HTTP_REFERER'] = 'http://example.com'
      assert_difference('Contact.count', 1) do
        post :create, locale: 'de', section: 'refugees', contact: contact_attrs
      end
      assert_redirected_to :section_choice
    end

    it 'should work with valid report data' do
      contact_attrs = FactoryGirl.attributes_for :report
      request.env['HTTP_REFERER'] = 'http://example.com'
      assert_difference('Contact.count', 1) do
        post :create, locale: 'de', section: 'family', contact: contact_attrs
      end
      assert_redirected_to :section_choice
    end

    it 'should not work with empty data' do
      assert_difference('Contact.count', 0) do
        post :create, locale: 'de', section: 'refugees', contact: { name: '' }
      end
      assert_template :new
    end
  end

  describe "GET 'index'" do
    it 'should redirect to new' do
      get :index, locale: 'de', section: 'family'
      assert_redirected_to :new_contact
    end
  end
end
