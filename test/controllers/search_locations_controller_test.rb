# frozen_string_literal: true
require_relative '../test_helper'

describe SearchLocationsController do
  describe "GET 'show'" do
    it 'should respond with data about a SearchLocation' do
      sl = FactoryGirl.build :search_location # don't save to avoid API request
      SearchLocation.expects(:find_by).with(
        query: sl.query.strip.titleize
      ).returns(sl)
      get :show, params: { locale: 'de', format: :json, id: sl.query }
      assert_response :success
    end
  end
end
