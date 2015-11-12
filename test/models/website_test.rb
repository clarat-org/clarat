require_relative '../test_helper'

describe Website do
  let(:website) do
    Website.new(host: 'own', url: 'http://www.clarat.org/example')
  end

  subject { website }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :host }
    it { subject.must_respond_to :url }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :host }
      it { subject.must validate_presence_of :url }
      it { subject.must validate_uniqueness_of :url }
    end
  end

  describe 'Methods' do
    describe '#shorten_url' do
      it 'should return only the url essence' do
        website.shorten_url.must_equal 'www.clarat.org'
      end
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :hyperlinks }
    end
  end
end
