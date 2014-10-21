require_relative '../test_helper'

describe Organization do

  let(:organization) { Organization.new }

  subject { organization }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :description }
    it { subject.must_respond_to :legal_form }
    it { subject.must_respond_to :charitable }
    it { subject.must_respond_to :founded }
    it { subject.must_respond_to :umbrella }
    it { subject.must_respond_to :slug }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :keywords }
    it { subject.must_respond_to :completed }
    it { subject.must_respond_to :approved }
  end

  describe 'validations' do
    describe 'always' do # TODO: Wieso, weshalb, warum?
      # Can I test the format here as well? What about custom validations?
      it { subject.must validate_presence_of :name }
      it { subject.must validate_uniqueness_of :name }
      it { subject.must ensure_length_of(:name).is_at_most 100 }
      it { subject.must validate_presence_of :description }
      it { subject.must ensure_length_of(:description).is_at_most 400 }
      it { subject.must validate_presence_of :legal_form }
      it { subject.must ensure_length_of(:keywords).is_at_most 150 }
    end
  end

  describe '::Base' do # TODO: Wieso, weshalb, warum?
    describe 'associations' do
      # What about has_many_through
      it { subject.must have_many :offers }
      it { subject.must have_many :locations }
      it { subject.must have_many :hyperlinks }
      it { subject.must have_many :websites }
    end
  end
end