require_relative '../test_helper'

class OffersHelperTest < ActionView::TestCase
  include OffersHelper

  let(:offer) { FactoryGirl.create(:offer) }

  describe '#tel_format' do
    it 'should format a phone number' do
      tel_format('3656558').must_equal ' 36 56 55 8'
    end
  end

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

  describe '#offer_with_contacts' do
    before do
      offer.contact_people << FactoryGirl.create(:contact_person, :all_fields, :with_telephone, organization: offer.organizations.first)
      offer.contact_people.first.update_attributes last_name: 'two'
      offer.contact_people.last.update_attributes last_name: 'one'
    end

    it 'orders contacts alphabetically by last name' do
      offer_with_contacts(offer).first.last_name.must_equal 'one'
    end
  end

  describe '#display_contacts?' do

    describe 'with no spoc contact and no hidden contacts' do
      it 'should equal true' do
        display_contacts?(offer, offer.contact_people.first).must_equal true
      end
    end

    describe 'with no spoc contact and hidden contacts' do
      before do
        offer.assign_attributes hide_contact_people: true
      end

      it 'should equal false' do
        display_contacts?(offer, offer.contact_people.first).must_equal false
      end
    end

    describe 'with a spoc contact and hidden contacts' do
      before do
        offer.assign_attributes hide_contact_people: true
        offer.contact_people.first.assign_attributes spoc: true
      end

      it 'should equal true' do
        display_contacts?(offer, offer.contact_people.first).must_equal true
      end
    end

    describe 'with a spoc contact and no hidden contacts' do
      before do
        offer.contact_people.first.assign_attributes spoc: true
      end

      it 'should equal true' do
        display_contacts?(offer, offer.contact_people.first).must_equal true
      end
    end
  end

  describe '#contact_name' do
  end

  describe '#contact_gender' do
  end

  describe '#contact_academic_title' do
  end

  describe '#contact_full_name' do
  end
end
