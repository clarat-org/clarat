require_relative '../test_helper'

class OffersHelperTest < ActionView::TestCase
  include OffersHelper

  describe '#tel_format' do
    it 'should format a phone number' do
      tel_format('3656558').must_equal ' 36 56 55 8'
    end
  end

  describe '#category_list_classes' do
    it 'should produce the correct string without children' do
      category_list_classes(2, []).must_equal 'depth--2 '
    end

    it 'should produce the correct string with children' do
      category_list_classes(1, ['whatever']).must_equal 'depth--1 has-children'
    end

    it 'should neglect having children when the depth is greater 1' do
      category_list_classes(2, ['whatever']).must_equal 'depth--2 '
    end
  end
end
