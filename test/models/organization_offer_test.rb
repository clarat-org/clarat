require_relative '../test_helper'

describe OrganizationOffer do
  let(:organization_offer) { OrganizationOffer.new }

  subject { organization_offer }

  it  { subject.must_be :valid? }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :offer }
    it { subject.must_respond_to :offer_id }
    it { subject.must_respond_to :organization }
    it { subject.must_respond_to :organization_id }
  end
end
