require_relative '../test_helper'

class OffersHelperTest < ActionView::TestCase
  include OffersHelper

  describe '#tel_format' do
    it 'should format a phone number' do
      tel_format('3656558').must_equal ' 36 56 55 8'
    end
  end
end
