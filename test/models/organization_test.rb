require_relative '../test_helper'

describe Organization do
  let(:organization) do
    Organization.new(name: 'Testname',
                     description: 'Testbeschreibung',
                     legal_form: 'ev')
  end # Necessary to test uniqueness
  let(:orga) { organizations(:basic) }

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

  describe 'State Machine' do
    describe 'initialized' do
      it 'should complete' do
        organization.complete
        organization.must_be :completed?
      end

      it 'wont approve' do
        assert_raises(AASM::InvalidTransition) { organization.approve }
        organization.must_be :initialized?
      end

      it 'wont deactivate_internal' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_internal
        end
        organization.must_be :initialized?
      end

      it 'wont deactivate_external' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_external
        end
        organization.must_be :initialized?
      end
    end

    describe 'completed' do
      before { organization.aasm_state = :completed }

      it 'should approve with a different actor' do
        organization.stubs(:different_actor?).returns(true)
        organization.approve
        organization.must_be :approved?
      end

      it 'wont approve with the same actor' do
        organization.stubs(:different_actor?).returns(false)
        assert_raises(AASM::InvalidTransition) { organization.approve }
        organization.must_be :completed?
      end

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :completed?
      end

      it 'wont deactivate_internal' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_internal
        end
        organization.must_be :completed?
      end

      it 'wont deactivate_external' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_external
        end
        organization.must_be :completed?
      end
    end

    describe 'approved' do
      before { organization.aasm_state = :approved }

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :approved?
      end

      it 'wont approve' do
        assert_raises(AASM::InvalidTransition) { organization.approve }
        organization.must_be :approved?
      end

      it 'must deactivate_internal' do
        organization.deactivate_internal
        organization.must_be :internal_feedback?
      end

      it 'must deactivate_external' do
        organization.deactivate_external
        organization.must_be :external_feedback?
      end
    end

    describe 'internal_feedback' do
      before { organization.aasm_state = :internal_feedback }

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :internal_feedback?
      end

      it 'must approve, even with same actor' do
        organization.stubs(:different_actor?).returns(false)
        organization.approve
        organization.must_be :approved?
      end

      it 'wont deactivate_internal' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_internal
        end
        organization.must_be :internal_feedback?
      end

      it 'must deactivate_external' do
        organization.deactivate_external
        organization.must_be :external_feedback?
      end
    end

    describe 'external_feedback' do
      before { organization.aasm_state = :external_feedback }

      it 'wont complete' do
        assert_raises(AASM::InvalidTransition) { organization.complete }
        organization.must_be :external_feedback?
      end

      it 'must approve, even with same actor' do
        organization.stubs(:different_actor?).returns(false)
        organization.approve
        organization.must_be :approved?
      end

      it 'must deactivate_internal' do
        organization.deactivate_internal
        organization.must_be :internal_feedback?
      end

      it 'wont deactivate_external' do
        assert_raises(AASM::InvalidTransition) do
          organization.deactivate_external
        end
        organization.must_be :external_feedback?
      end
    end

    describe 'deactivate_offers!' do
      it 'should deactivate an approved offer belonging to this organization' do
        orga.offers.first.must_be :approved?
        orga.update_column :aasm_state, :internal_feedback
        orga.deactivate_offers!
        orga.offers.first.must_be :organization_deactivated?
      end

      it 'should raise an error when deactivation fails for an offer' do
        Offer.any_instance.expects(:deactivate_through_organization!)
          .returns(false)

        assert_raise(RuntimeError) { orga.deactivate_offers! }
      end
    end

    describe 'reactivate_offers!' do
      let(:offer) { offers(:basic) }
      it 'should reactivate an associated organization_deactivated offer' do
        offer.update_column :aasm_state, :organization_deactivated
        orga.reactivate_offers!
        offer.reload.must_be :approved?
      end

      it 'wont approve offers, that have another deactivated orga' do
        offer.update_column :aasm_state, :organization_deactivated
        offer.organizations <<
          FactoryGirl.create(:organization, aasm_state: 'external_feedback')

        orga.reactivate_offers!
        offer.reload.must_be :organization_deactivated?
      end
    end
  end
end
