require_relative '../test_helper'

class OffersHelperTest < ActionView::TestCase
  include OffersHelper

  describe '#category_list_classes' do
    it 'should produce the correct string without children' do
      category_list_classes(2, [], 'family').must_equal 'depth--2 '
    end

    it 'should produce the correct string with children' do
      category_list_classes(1, [[FactoryGirl.create(:category)]], 'refugees').must_equal 'depth--1 has-children'
    end

    it 'should neglect having children when the depth is greater 3' do
      category_list_classes(4, [[FactoryGirl.create(:category)]], 'refugees').must_equal 'depth--4 '
    end

    it 'should produce the correct string with invisible children' do
      category_list_classes(1, [[FactoryGirl.create(:category, visible: false)]], 'refugees').must_equal 'depth--1 '
    end
  end
end
