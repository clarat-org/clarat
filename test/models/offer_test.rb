require_relative '../test_helper'

describe Offer do

  let(:offer) { Offer.new }

  subject { offer }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :description }
    it { subject.must_respond_to :next_steps }
    it { subject.must_respond_to :telephone }
    it { subject.must_respond_to :email }
    it { subject.must_respond_to :encounter }
    it { subject.must_respond_to :frequent_changes }
    it { subject.must_respond_to :slug }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :organization_id }
    it { subject.must_respond_to :fax }
    it { subject.must_respond_to :opening_specification }
    it { subject.must_respond_to :comment }
    it { subject.must_respond_to :completed }
    it { subject.must_respond_to :second_telephone }
    it { subject.must_respond_to :approved }
    it { subject.must_respond_to :legal_information }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must ensure_length_of(:name).is_at_most 80 }
      it { subject.must validate_presence_of :description }
      it { subject.must ensure_length_of(:description).is_at_most 400 }
      it { subject.must validate_presence_of :next_steps }
      it { subject.must ensure_length_of(:next_steps).is_at_most 500 }
      it { subject.must validate_presence_of :encounter }
      it { subject.must ensure_length_of(:fax).is_at_most 32 }
      it { subject.must ensure_length_of(:telephone).is_at_most 32 }
      it { subject.must ensure_length_of(:second_telephone).is_at_most 32 }
      it { offer.must ensure_length_of(:opening_specification).is_at_most 400 }
      it { subject.must ensure_length_of(:comment).is_at_most 800 }
      it { subject.must validate_presence_of :organization_id }
      it { subject.must ensure_length_of(:legal_information).is_at_most 400 }
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must belong_to :location }
      it { subject.must belong_to :organization }
      it { subject.must have_and_belong_to_many :tags }
      it { subject.must have_and_belong_to_many :languages }
      it { subject.must have_and_belong_to_many :openings }
      it { subject.must have_many :hyperlinks }
      it { subject.must have_many :websites }
    end
  end

  describe 'methods' do
    describe '#creator_email' do
      it 'should return anonymous by default' do
        offer.creator_email.must_equal 'anonymous'
      end

      it 'should return users email if there is a a version' do
        user = FactoryGirl.create :user
        offer.stub_chain(:versions, :first, :whodunnit).returns 1
        offer.creator_email.must_equal user.email
      end
    end

    describe '#encounter_value' do
      it 'should return 0 on independent' do
        Offer.new(encounter: :independent).encounter_value.must_equal 0
      end

      it 'should return 1 on determinable' do
        Offer.new(encounter: :determinable).encounter_value.must_equal 1
      end

      it 'should return 1 on fixed' do
        Offer.new(encounter: :fixed).encounter_value.must_equal 1
      end
    end

    describe '#contact_details?' do
      it 'should return true when one field is filled' do
        Offer.new(email: 'a@b.c').contact_details?.must_equal true
      end
      it 'should return true when multiple fields are filled' do
        Offer.new(email: 'a@b.c', fax: '1').contact_details?.must_equal true
      end
      it 'should return false when no contact fields are filled' do
        Offer.new.contact_details?.must_equal false
      end
    end

    describe '#social_media_websites?' do
      it 'should return true when offer has a "social" website' do
        offers(:basic).websites << FactoryGirl.create(:website, :social)
        offers(:basic).social_media_websites?.must_equal true
      end
      it 'should return false when offer has no "social" website' do
        offers(:basic).websites << FactoryGirl.create(:website, :own)
        offers(:basic).social_media_websites?.must_equal false
      end
    end

    describe '#add_dependent_tags (tags after_add callback)' do
      it 'should add dependent tags over multiple levels' do
        tag1 = Tag.create name: 'foobar'
        tag2 = Tag.create name: 'dependent1'
        tag3 = Tag.create name: 'dependent2'
        tag1.dependent_tags << tag2
        tag2.dependent_tags << tag3

        offers(:basic).tags << tag1
        offers(:basic).tags.must_include tag2
        offers(:basic).tags.must_include tag3
      end

      it 'should not break with recursive dependencies' do
        tag1 = Tag.create name: 'dependent1'
        tag2 = Tag.create name: 'dependent2'
        tag1.dependent_tags << tag2
        tag2.dependent_tags << tag1

        offers(:basic).tags << tag1
        offers(:basic).tags.must_equal [tag1, tag2]
      end
    end
  end
end
