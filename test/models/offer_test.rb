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
    it { subject.must_respond_to :keywords }
    it { subject.must_respond_to :completed }
    it { subject.must_respond_to :second_telephone }
    it { subject.must_respond_to :approved }
  end

  describe 'validations' do
    describe 'always' do
      it { offer.must validate_presence_of :name }
    end
  end
end