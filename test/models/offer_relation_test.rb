require_relative '../test_helper'

describe OfferRelation do
  let(:offer_relation) { OfferRelation.new }

  subject { offer_relation }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :offer_id }
    it { subject.must_respond_to :related_id }
  end

  describe 'associations' do
    it { subject.must belong_to :offer }
    it { subject.must belong_to :related }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :offer }
    it { subject.must validate_presence_of :related }
  end
end
