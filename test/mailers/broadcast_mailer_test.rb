require_relative '../test_helper'

describe BroadcastMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:contact_person) do
    FactoryGirl.create :contact_person,
                       { email: 'foo@bar.baz',
                         offers: [offers(:basic)] }.merge(options)
  end
  let(:options) { {} }

  subject { BroadcastMailer.welcome contact_person }

  describe '#welcome' do
    it 'must deliver' do
      subject.must deliver_to 'foo@bar.baz'
      subject.must have_body_text 'clarat'
    end

    describe 'for a genderless contact person' do
      let(:options) { { gender: nil } }

      it 'must address them correctly' do
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
      let(:options) { { gender: 'male', first_name: 'Foo', last_name: 'Bar' } }

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
end
