require_relative '../test_helper'

class OffersHelperTest < ActionView::TestCase
  include OffersHelper

  describe '#tel_format' do
    it 'should format a phone number' do
      tel_format('3656558').must_equal ' 36 56 55 8'
    end
  end

  describe '#category_list_classes' do
    it 'should produce the correct string with children' do
      category_list_classes(2, []).must_equal 'depth--2 '
    end
    it 'should produce the correct string without children' do
      category_list_classes(3, ['whatever']).must_equal 'depth--3 has-children'
    end
  end
end
