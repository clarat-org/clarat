require_relative '../test_helper'

describe Offer do
  let(:offer) { Offer.new }
  let(:basicOffer) { offers(:basic) }

  subject { offer }

  describe '#organization_display_name' do
    it "should return the first organization's name if there is only one" do
      offers(:basic).organization_display_name.must_equal(
        organizations(:basic).name
      )
    end

    it 'should return a string when there are multiple organizations' do
      offers(:basic).organizations << FactoryGirl.create(:organization)
      offers(:basic).organization_display_name.must_equal(
        I18n.t('js.search_results.map.cooperation')
      )
    end
  end

  describe 'language_filters' do
    before do
      LanguageFilter.create name: 'Litauisch', identifier: 'lit'
      LanguageFilter.create name: 'Bosnisch', identifier: 'bos'
      LanguageFilter.create name: 'Kikuyu', identifier: 'kik'
      offers(:basic).language_filters = LanguageFilter.all
    end

    it 'should correctly return fixed sorted language_filters' do
      offers(:basic).language_filters_fixed.must_equal(%w(deu eng))
    end

    it 'should correctly return the remaining language_filters sorted by name' do
      offers(:basic).language_filters_without_fixed.must_equal(%w(bos kik lit))
    end
  end
end
