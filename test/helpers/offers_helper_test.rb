require_relative '../test_helper'

class OffersHelperTest < ActionView::TestCase
  include OffersHelper

  describe '#tel_format' do
    it 'should format a phone number' do
      tel_format('0303656558').must_equal '030 36 56 55 8'
    end
  end
end
