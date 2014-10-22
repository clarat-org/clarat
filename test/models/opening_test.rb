require_relative '../test_helper'

describe Opening do

  let(:opening) { Opening.new(day: 'mon',
                              open: Time.now,
                              close: Time.now + 1.hour) }

  subject { opening }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :day }
    it { subject.must_respond_to :open }
    it { subject.must_respond_to :close }
    it { subject.must_respond_to :sort_value }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :day }
      it { subject.must validate_presence_of :open }
      it { subject.must validate_uniqueness_of(:open).scoped_to([:day, :close]) }
      it { subject.must validate_presence_of :close }
      it { subject.must validate_uniqueness_of(:close).scoped_to([:day, :open]) }
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_and_belong_to_many :offers }
    end
  end
end
