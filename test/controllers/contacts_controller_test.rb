# frozen_string_literal: true
require_relative '../test_helper'

describe ContactsController do
  describe "GET 'new'" do
    it 'should work' do
      get :new, params: { locale: 'de', section: 'family' }
      assert_response :success
      assert_template :new
    end
  end

  describe 'GET power user popup contact form' do
    it 'should work' do
      offer = offers(:basic)
      get :new, params: { id: offer.slug, locale: 'de', section: 'family' }
      assert_response :success
    end
  end

  describe "POST 'create'" do
    it 'should work with valid contact data' do
      contact_attrs = FactoryGirl.attributes_for :contact
      request.env['HTTP_REFERER'] = 'http://example.com'
      assert_difference('Contact.count', 1) do
        post :create, params: { locale: 'de', section: 'refugees', contact: contact_attrs }
      end
      assert_redirected_to request.referer
    end

    it 'should work with valid report data' do
      contact_attrs = FactoryGirl.attributes_for :report
      request.env['HTTP_REFERER'] = 'http://example.com'
      assert_difference('Contact.count', 1) do
        post :create, params: { locale: 'de', section: 'family', contact: contact_attrs }
      end
      assert_redirected_to request.referer
    end

    it 'should not work with empty data' do
      assert_difference('Contact.count', 0) do
        post :create, params: { locale: 'de', section: 'refugees', contact: { name: '' } }
      end
      assert_template :new
    end

    it 'should not work with empty form data for popup contact form' do
      post :create, params: { locale: 'de', section: 'refugees', contact: { message: 'Ich möchte an der Umfrage teilnehmen', name: '' } }
      assert_template 'popup.js'
    end
  end

  describe "GET 'index'" do
    it 'should redirect to new' do
      get :index, params: { locale: 'de', section: 'family' }
      assert_redirected_to :new_contact
    end
  end
end
