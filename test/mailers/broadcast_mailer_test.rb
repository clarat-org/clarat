require_relative '../test_helper'

describe BroadcastMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:contact_person) do
    FactoryGirl.create :contact_person, email: 'foo@bar.baz',
                                        offers: [offers(:basic)]
  end

  describe '#welcome' do
    it 'must deliver' do
      mail = BroadcastMailer.welcome contact_person
      mail.must deliver_to 'foo@bar.baz'
      mail.must have_body_text contact_person.name
    end
  end
end
