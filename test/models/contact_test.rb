require_relative '../test_helper'

describe Contact do
  let(:contact) { Contact.new }
  subject { contact }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :email }
    it { subject.must_respond_to :message }
    it { subject.must_respond_to :url }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_presence_of :message }
    end

    describe 'on normal contact' do
      it { subject.must validate_presence_of :email }
    end

    describe 'on report' do
      let(:contact) { Contact.new reporting: true }
      it { subject.wont validate_presence_of :email }
    end
  end
end
