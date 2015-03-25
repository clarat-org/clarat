require_relative '../test_helper'

describe Offer do
  let(:offer) { Offer.new }

  subject { offer }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :description }
    it { subject.must_respond_to :next_steps }
    it { subject.must_respond_to :slug }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :opening_specification }
    it { subject.must_respond_to :comment }
    it { subject.must_respond_to :completed }
    it { subject.must_respond_to :approved }
    it { subject.must_respond_to :legal_information }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_length_of(:name).is_at_most 80 }
      it { subject.must validate_presence_of :description }
      it { subject.must validate_length_of(:description).is_at_most 450 }
      it { subject.must validate_presence_of :next_steps }
      it { subject.must validate_length_of(:next_steps).is_at_most 500 }
      it { subject.must validate_length_of(:comment).is_at_most 800 }
      it { subject.must validate_length_of(:legal_information).is_at_most 400 }
      it { subject.must validate_presence_of :expires_at }
      it do
        subject.must validate_length_of(:opening_specification).is_at_most 400
      end
    end

    describe 'custom' do
      it 'should validate expiration date' do
        subject.expires_at = Time.now
        subject.valid?
        subject.errors.messages[:expires_at].must_include(
          I18n.t('validations.shared.later_date')
        )
      end
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must belong_to :location }
      it { subject.must have_many :organization_offers }
      it { subject.must have_many(:organizations).through :organization_offers }
      it { subject.must have_and_belong_to_many :categories }
      it { subject.must have_and_belong_to_many :filters }
      it { subject.must have_and_belong_to_many :language_filters }
      it { subject.must have_and_belong_to_many :audience_filters }
      it { subject.must have_and_belong_to_many :age_filters }
      it { subject.must have_and_belong_to_many :encounter_filters }
      it { subject.must have_and_belong_to_many :openings }
      it { subject.must have_many :hyperlinks }
      it { subject.must have_many :websites }
    end
  end

  describe 'methods' do
    describe '#creator' do
      it 'should return anonymous by default' do
        offer.creator.must_equal 'anonymous'
      end

      it 'should return users name if there is a version' do
        offer = FactoryGirl.create :offer, :with_creator
        offer.creator.must_equal User.find(offer.created_by).name
      end
    end

    describe '#contact_details?' do
      it 'should return true when offer has a website' do
        offer.websites = [Website.new]
        offer.contact_details?.must_equal true
      end
      it 'should return true when offer has a contact person' do
        offer.contact_people = [ContactPerson.new]
        offer.contact_details?.must_equal true
      end
      it 'should return false when no contact details are available' do
        offer.contact_details?.must_equal false
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

    describe '#_tags' do
      it 'should return unique categories with ancestors of an offer' do
        offers(:basic).categories << categories(:sub1)
        offers(:basic).categories << categories(:sub2)
        tags = offers(:basic)._tags
        tags.must_include 'sub1.1'
        tags.must_include 'sub1.2'
        tags.must_include 'main1'
        tags.count('main1').must_equal 1
        tags.wont_include 'main2'
      end
    end

    describe '#organization_display_name' do
      it "should return the first organization's name if there is only one" do
        offers(:basic).organization_display_name.must_equal(
          organizations(:basic).name
        )
      end

      it 'should return a string when there are multiple organizations' do
        offers(:basic).organizations << FactoryGirl.create(:organization)
        offers(:basic).organization_display_name.must_equal(
          I18n.t('offers.index.cooperation')
        )
      end
    end

    describe '::per_env_index' do
      it 'should return Offer_envname for a non-development env' do
        Offer.per_env_index.must_equal 'Offer_test'
      end

      it 'should attach the user name to the development env' do
        Rails.stubs(:env)
          .returns ActiveSupport::StringInquirer.new('development')
        ENV.stubs(:[]).returns 'foobar'
        Offer.per_env_index.must_equal 'Offer_development_foobar'
      end
    end
  end
end
