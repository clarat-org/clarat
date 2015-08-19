require_relative '../test_helper'

describe OrganizationConnection do
  let(:organization_connection) { OrganizationConnection.new }
  subject { organization_connection }

  it { subject.wont_be :valid? }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :parent_id }
    it { subject.must_respond_to :child_id }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :parent_id }
    it { subject.must validate_presence_of :child_id }
  end
end
