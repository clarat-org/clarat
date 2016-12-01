require_relative '../test_helper'

class IndexChoiceTest < ActionView::TestCase
  include IndexChoice

  describe '#IndexChoice.personal' do
    it 'should respond correctly with namend index in testing scenario' do
      IndexChoice.personal.must_equal Offer.personal_index_name(I18n.locale)
    end

    it 'should respond correctly for force_production_index' do
      Rails.application.secrets.stubs(:force_production_index).returns true
      IndexChoice.personal.must_equal "Offer_production_personal_#{I18n.locale}"
    end
  end

  describe '#IndexChoice.remote' do
    it 'should respond correctly with namend index in testing scenario' do
      IndexChoice.remote.must_equal Offer.remote_index_name(I18n.locale)
    end

    it 'should respond correctly for force_production_index' do
      Rails.application.secrets.stubs(:force_production_index).returns true
      IndexChoice.remote.must_equal "Offer_production_remote_#{I18n.locale}"
    end
  end
end
