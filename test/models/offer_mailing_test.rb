require_relative '../test_helper'

describe OfferMailing do
  let(:offer_mailing) { OfferMailing.new }

  subject { offer_mailing }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :mailing_type }
    it { subject.must_respond_to :offer_id }
    it { subject.must_respond_to :email_id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'associations' do
    it { subject.must belong_to :offer }
    it { subject.must belong_to :email }
  end
end
