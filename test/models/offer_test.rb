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
end
