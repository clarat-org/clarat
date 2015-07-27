require_relative '../test_helper'

describe ContactPersonOffer do
  let(:contact_person_offer) { ContactPersonOffer.new }
  subject { contact_person_offer }

  describe 'validations' do
    describe 'always' do
      # TODO: Refactor or delete!
      # it { subject.must validate_presence_of(:offer_id) }
      # it { subject.must validate_presence_of(:contact_person_id) }
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must belong_to :offer }
      it { subject.must belong_to :contact_person }
    end
  end
end
