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

  describe '#default_canonical_url' do
    before do
      @request = MiniTest::Mock.new
      expects(:request).returns(@request)
    end

    it 'replaces the non-default family section with the default refugees' do
      @request.expect(:url, 'http://some.host/family')
      default_canonical_url.must_equal('http://some.host/refugees')
    end

    it 'replaces another non-default section with the default refugees' do
      # setup
      original_section_identifiers = Section::IDENTIFIER
      silence_warnings do
        Section::IDENTIFIER = %w(family somethingelse refugees)
      end

      # test
      @request.expect(:url, 'http://some.host/somethingelse/')
      default_canonical_url.must_equal('http://some.host/refugees/')

      # cleanup
      silence_warnings do
        Section::IDENTIFIER = original_section_identifiers
      end
    end

    it 'leaves the default intact' do
      @request.expect(:url, 'http://some.host/refugees/')
      default_canonical_url.must_equal('http://some.host/refugees/')
    end

    it 'replaces a non-default in the middle of the URL string' do
      @request.expect(:url, 'http://some.host/family/angebote?bla=bla')
      default_canonical_url.must_equal(
        'http://some.host/refugees/angebote?bla=bla'
      )
    end

    it 'replaces only the first section part of the URL' do
      @request.expect(:url, 'http://some.host/family/angebote?query=family')
      default_canonical_url.must_equal(
        'http://some.host/refugees/angebote?query=family')
    end

    it 'shouldnt replace any part other than the section part, even if it'\
       ' contains a non-default string' do
      @request.expect(:url, 'http://some.host/refugees/angebote?query=family')
      default_canonical_url.must_equal(
        'http://some.host/refugees/angebote?query=family')
    end
  end

  describe '#inverse_section' do
    it 'should return "family" when given "refugees"' do
      inverse_section('refugees').must_equal 'family'
    end

    it 'should return "refugees" when given "family"' do
      inverse_section('family').must_equal 'refugees'
    end
  end
end
