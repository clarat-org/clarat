# frozen_string_literal: true
require_relative '../test_helper'

describe Category do
  let(:category) { Category.new }

  subject { category }

  describe 'methods' do
    describe '#offers_in_section?' do
      it 'should return true when requested category has approved offers' do
        category = categories(:sub1)
        category.offers_in_section?(:family).must_equal false
        offer = FactoryGirl.create :offer, section: :family, category: category
        category.offers_in_section?(:family).must_equal false
        offer.update_column :aasm_state, :approved
        category.reload.offers_in_section?(:family).must_equal true
      end

      it 'should return true when a child has approved offers' do
        category = categories(:main1)
        category.offers_in_section?(:family).must_equal false
        FactoryGirl.create :offer, :approved,
                           section: :family, category: category.children.first
        category.offers_in_section?(:family).must_equal true
      end

      it 'should return false when only a parent has approved offers' do
        category = categories(:sub1)
        FactoryGirl.create :offer, :approved,
                           section: :family, category: category.parent
        category.offers_in_section?(:family).must_equal false
      end

      it 'should return false when there are only offers in another section' do
        category = categories(:sub1)
        FactoryGirl.create :offer, :approved,
                           section: :family, category: category
        category.offers_in_section?(:refugees).must_equal false
      end
    end
  end
end
