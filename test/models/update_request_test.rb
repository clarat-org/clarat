require_relative '../test_helper'

describe UpdateRequest do
  let(:update_request) { UpdateRequest.new }
  subject { update_request }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :search_location }
    it { subject.must_respond_to :email }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :search_location }

      it 'must have valid state' do
        update_request.assign_attributes search_location: 'x', email: 'a@b.c'
        update_request.must_be :valid?
      end
    end
  end
end
