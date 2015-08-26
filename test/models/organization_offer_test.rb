require_relative '../test_helper'

describe OrganizationOffer do
  let(:organization_offer) { OrganizationOffer.new }

  subject { organization_offer }

  it { subject.must_be :valid? }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :offer }
    it { subject.must_respond_to :offer_id }
    it { subject.must_respond_to :organization }
    it { subject.must_respond_to :organization_id }
  end

  describe 'callbacks' do
    it 'should be destroyed when organization is destroyed' do
      oo = FactoryGirl.create :organization_offer
      offer = oo.offer
      oo.organization.destroy!
      assert_raises(ActiveRecord::RecordNotFound) { oo.reload }
      offer.reload # offer still exists
    end

    it 'should be destroyed when offer is destroyed' do
      oo = FactoryGirl.create :organization_offer
      organization = oo.organization
      oo.offer.destroy!
      assert_raises(ActiveRecord::RecordNotFound) { oo.reload }
      organization.reload # organization still exists
    end
  end
end
