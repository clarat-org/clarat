require_relative '../test_helper'

describe Statistic do
  let(:statistic) { Statistic.new topic: :offer_created, x: Date.current, y: 1 }
  subject { statistic }

  it { subject.must_be :valid? }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :topic }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :x }
    it { subject.must_respond_to :y }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :topic }
    it { subject.must validate_presence_of :x }
    it { subject.must validate_presence_of :y }
    it { subject.must validate_numericality_of :y }
  end

  describe 'associations' do
    it { subject.must belong_to :user }
  end
end
