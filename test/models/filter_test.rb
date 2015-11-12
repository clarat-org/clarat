require_relative '../test_helper'

describe Filter do
  let(:filter) { Filter.new }

  subject { filter }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :identifier }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_uniqueness_of :name }
      it { subject.must validate_presence_of :identifier }
      it { subject.must validate_uniqueness_of :identifier }
    end

    describe 'LanguageFilter' do
      it { LanguageFilter.new.must validate_length_of(:identifier).is_equal_to 3 }
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_and_belong_to_many :offers }
    end
  end
end
