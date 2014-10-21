require_relative '../test_helper'

describe SearchLocation do

  let(:search_location) { SearchLocation.new(query: 'Berlin',
                                             latitude: 52.520007,
                                             longitude: 13.404954,
                                             geoloc: '52.520007,13.404954') }

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
      it { subject.must validate_presence_of :latitude }
      it { subject.must validate_presence_of :longitude }
    end
  end
end
