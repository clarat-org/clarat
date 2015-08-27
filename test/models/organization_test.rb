require_relative '../test_helper'

describe Organization do
  let(:organization) do
    Organization.new(name: 'Testname',
                     description: 'Testbeschreibung',
                     legal_form: 'ev')
  end # Necessary to test uniqueness

  subject { organization }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :description }
    it { subject.must_respond_to :legal_form }
    it { subject.must_respond_to :charitable }
    it { subject.must_respond_to :founded }
    it { subject.must_respond_to :umbrella }
    it { subject.must_respond_to :slug }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :comment }
    it { subject.must_respond_to :aasm_state }
    it { subject.must_respond_to :mailings_enabled }
  end

  describe 'validations' do
    describe 'always' do # TODO: Wieso, weshalb, warum?
      # Can I test the format here as well? What about custom validations?
      it { subject.must validate_presence_of :name }
      it { subject.must validate_length_of(:name).is_at_most 100 }
      it { subject.must validate_uniqueness_of :name }
      it { subject.must validate_presence_of :description }
      it { subject.must validate_length_of(:description).is_at_most 400 }
      it { subject.must validate_presence_of :legal_form }
      it { subject.must validate_length_of(:comment).is_at_most 800 }
      it { subject.must validate_uniqueness_of :slug }
    end
  end

  describe '::Base' do # TODO: Wieso, weshalb, warum?
    describe 'associations' do
      # What about has_many_through
      it { subject.must have_many :offers }
      it { subject.must have_many :locations }
      it { subject.must have_many :hyperlinks }
      it { subject.must have_many :websites }
      it { subject.must have_many :child_connections }
      it { subject.must have_many(:children).through :child_connections }
      it { subject.must have_many :parent_connections }
      it { subject.must have_many(:parents).through :parent_connections }
    end
  end

  describe 'Observer' do
    describe 'before_create' do
      it 'should not change a created_by' do
        organization.created_by = 123
        organization.save!
        organization.created_by.must_equal 123
      end

      it 'should set created_by if it doesnt exist' do
        organization.created_by = nil
        organization.save!
        organization.created_by.must_equal ::PaperTrail.whodunnit
        # Note we have a spec helper for PaperTrail
      end
    end
  end
end
