require_relative '../test_helper'

describe SearchLocation do
  let(:search_location) { SearchLocation.new(query: 'Foobar') }

  subject { search_location }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :query }
    it { subject.must_respond_to :latitude }
    it { subject.must_respond_to :longitude }
    it { subject.must_respond_to :geoloc }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :query }
      it { subject.must validate_uniqueness_of :query }
      # it { subject.must validate_presence_of :latitude }
      # it { subject.must validate_presence_of :longitude }
    end
  end

  describe 'methods' do
    describe '#set_geoloc' do
      it 'should set the geolocation before saving' do
        search_location.geoloc = nil
        search_location.save!
        search_location.geoloc.must_equal '10.0,20.0'
      end
    end
  end
end
