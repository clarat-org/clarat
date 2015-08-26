require_relative '../test_helper'

describe OfferMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:offer) { offers(:basic) }
  let(:contact_person) do
    FactoryGirl.create :contact_person,
                       { email: email, offers: [offer] }.merge(options)
  end
  let(:options) { {} }

  describe '#expiring_mail' do
    it 'must deliver' do
      mail = OfferMailer.expiring_mail 1, [offer.id]
      mail.must deliver_from 'post@clarat.org'
      mail.must have_body_text '1 offer expired today:'
      mail.must have_body_text offer.id.to_s
    end
  end

  describe '#inform' do
    let(:email) do
      FactoryGirl.create :email, :with_security_code, address: 'foo@bar.baz'
    end

    subject { OfferMailer.inform email }
    before { contact_person }

    it 'must deliver and create offer_mailings' do
      email.expects(:create_offer_mailings)
      subject.must deliver_to 'foo@bar.baz'
      subject.must have_body_text 'clarat'
      subject.must have_body_text '/subscribe'
      subject.must have_body_text email.security_code
    end

    it 'only informs about offers by mailings_enabled organizations' do
      offer2 = FactoryGirl.create :offer, :approved,
                                  name: 'By mailings_enabled organization'
      offer2.contact_people.first.update_column :email_id, email.id

      offer3 = FactoryGirl.create :offer, :approved,
                                  name: 'By mailings_disabled organization'
      offer3.contact_people.first.update_column :email_id, email.id
      offer3.organizations.first.update_column :mailings_enabled, false

      assert_difference 'OfferMailing.count', 2 do
        subject.must have_body_text 'basicOfferName'
        subject.must have_body_text 'By mailings_enabled organization'
        subject.wont have_body_text 'By mailings_disabled organization'
      end
    end

    describe 'for a genderless contact person without a name' do
      let(:options) do
        { gender: nil, first_name: nil, last_name: nil, local_number_1: '1' }
      end

      it 'must address them correctly' do
        subject.must have_body_text 'Sehr geehrte Damen und Herren,'
      end
    end

    describe 'for an email with multiple contact people' do
      it 'must address them correctly' do
        FactoryGirl.create :contact_person, email: email
        subject.must have_body_text 'Sehr geehrte Damen und Herren,'
      end
    end

    describe 'for a male contact person with only a first name' do
      let(:options) { { gender: 'male', first_name: 'Foobar', last_name: '' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Lieber Foobar,'
      end
    end

    describe 'for a male contact person with first and last name' do
      let(:options) { { gender: 'male', first_name: 'X', last_name: 'Bar' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Lieber Herr Bar,'
      end
    end

    describe 'for a female contact person with only a last name' do
      let(:options) { { gender: 'female', first_name: '', last_name: 'Baz' } }

      it 'must address them correctly' do
        subject.must have_body_text 'Liebe Frau Baz,'
      end
    end

    describe 'for a female contact person with only a first name' do
      let(:options) { { gender: 'female', first_name: 'Fuz', last_name: nil } }

      it 'must address them correctly' do
        subject.must have_body_text 'Liebe Fuz,'
      end
    end
  end

  describe '#newly_approved_offers' do
    let(:email) { FactoryGirl.create :email, :with_security_code, :subscribed }
    before { contact_person }

    subject { OfferMailer.newly_approved_offers email, [offer] }

    it 'must deliver and create offer_mailings' do
      email.expects(:create_offer_mailings)
      subject.must deliver_to email.address
      subject.must have_body_text '/unsubscribe/'
      subject.must have_body_text email.security_code
    end
  end
end
