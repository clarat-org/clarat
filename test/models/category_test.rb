require_relative '../test_helper'

describe Category do
  let(:category) { Category.new }

  subject { category }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :name }
      it { subject.must validate_uniqueness_of :name }
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_and_belong_to_many :offers }
      it { subject.must have_many :organizations }
    end
  end

  describe 'methods' do
    describe '#name_with_optional_asterisk' do
      it 'should return name with asterisk for a main category' do
        category.assign_attributes icon: 'x', name: 'a'
        category.name_with_optional_asterisk.must_equal 'a*'
      end
      it 'should return name without asterisk for a non-main category' do
        category.name = 'a'
        category.name_with_optional_asterisk.must_equal 'a'
      end
    end
  end
end
