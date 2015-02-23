require_relative '../test_helper'

describe ContactPerson do
  let(:contact_person) { ContactPerson.new }

  subject { contact_person }

  describe 'attributes' do
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :telephone }
    it { subject.must_respond_to :second_telephone }
    it { subject.must_respond_to :email }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of(:organization_id) }
      it { subject.must ensure_length_of(:telephone).is_at_most 32 }
      it { subject.must ensure_length_of(:second_telephone).is_at_most 32 }

      describe 'custom' do
        describe '#at_least_one_field_present' do
          before { contact_person.organization_id = 1 }

          it 'should be invalid if no telephone/email/name are given' do
            contact_person.valid?.must_equal false
            contact_person.errors[:base].must_include(
              I18n.t('validations.contact_person.incomplete')
            )
          end
          it 'should be valid if name is given' do
            contact_person.name = 'John'
            contact_person.valid?.must_equal true
          end
          it 'should be valid if telephone is given' do
            contact_person.telephone = '123'
            contact_person.valid?.must_equal true
          end
          it 'should be valid if email is given' do
            contact_person.email = 'a@b.c'
            contact_person.valid?.must_equal true
          end
        end
      end
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must belong_to :organization }
      it { subject.must have_many :contact_person_offers }
      it { subject.must have_many(:offers).through :contact_person_offers }
    end
  end

  describe 'methods' do
    describe '#display_name' do
      it 'should show ID, name and organization name' do
        contact_person.assign_attributes id: 1, name: 'John Doe'
        contact_person.organization = Organization.new(name: 'ABC')
        contact_person.display_name.must_equal '#1 John Doe (ABC)'
      end
    end
  end
end
