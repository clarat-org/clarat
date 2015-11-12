require_relative '../test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  # describe '#geoloc_to_s' do
  #   it 'should read from cookie if one exists' do
  #     cookies[:last_search_location] = { query: 'foobar' }.to_json
  #     geoloc_to_s('anything').must_equal 'foobar'
  #   end
  #   it 'should otherwise return the default location if default coords given' do
  #     geoloc_to_s('52.520007,13.404954').must_equal 'Berlin'
  #   end
  #   it 'should otherwise find the Searchlocation from the db' do
  #     sl = SearchLocation.new query: 'barbaz'
  #     SearchLocation.expects(:find_by_geoloc).returns sl
  #     geoloc_to_s('anything').must_equal 'barbaz'
  #   end
  #   it 'should otherwise return the default location' do
  #     geoloc_to_s(Object).must_equal 'Berlin'
  #   end
  # end
end
