# frozen_string_literal: true

require_relative '../test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

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
        Section::IDENTIFIER = %w[family somethingelse refugees].freeze
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
        'http://some.host/refugees/angebote?query=family'
      )
    end

    it 'shouldnt replace any part other than the section part, even if it'\
       ' contains a non-default string' do
      @request.expect(:url, 'http://some.host/refugees/angebote?query=family')
      default_canonical_url.must_equal(
        'http://some.host/refugees/angebote?query=family'
      )
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
