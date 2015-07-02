require_relative '../test_helper'

describe Location do
  # Using 'let' because 'ArgumentError: let 'location' cannot override a method in Minitest::Spec. Please use another name.'
  let(:loc) { Location.new }

  subject { loc }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :street }
    it { subject.must_respond_to :addition }
    it { subject.must_respond_to :zip }
    it { subject.must_respond_to :city }
    it { subject.must_respond_to :area_code }
    it { subject.must_respond_to :local_number }
    it { subject.must_respond_to :email }
    it { subject.must_respond_to :hq }
    it { subject.must_respond_to :latitude }
    it { subject.must_respond_to :longitude }
    it { subject.must_respond_to :organization_id }
    it { subject.must_respond_to :federal_state_id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :display_name }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_length_of(:name).is_at_most 100 }
      it { subject.must validate_presence_of :street }
      it { subject.must validate_presence_of :zip }
      it { subject.must validate_length_of(:zip).is_equal_to 5 }
      it { subject.must validate_presence_of :city }
      it { subject.must validate_length_of(:area_code).is_at_most 6 }
      it { subject.must validate_length_of(:local_number).is_at_most 32 }
      it { subject.must validate_presence_of :organization_id }
      it { subject.must validate_presence_of :federal_state_id }
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :offers }
      it { subject.must belong_to :organization }
      it { subject.must belong_to :federal_state }
    end
  end

  describe 'methods' do
    describe '#generate_display_name' do
      before do
        loc.assign_attributes street: 'street',
                              city: 'city',
                              zip: 'zip',
                              organization_id: 1 # fixture Orga
      end

      it 'should show the location name if one exists' do
        loc.name = 'name'
        loc.generate_display_name
        loc.display_name.must_equal 'foobar, name (street zip city)'
      end

      it 'should not show a location name if none exists' do
        loc.display_name.must_be_nil
        loc.generate_display_name
        loc.display_name.must_equal 'foobar, street zip city'
      end
    end

    # this method is stubbed out for the entire rest of the test suite
    describe '#full_address' do
      it 'should return address and federal state name' do
        loc.assign_attributes street: 'street',
                              city: 'city',
                              zip: 'zip',
                              federal_state: FederalState.new(name: 'state')

        loc.send(:full_address).must_equal 'street, zip city state'
      end
    end
  end
end
