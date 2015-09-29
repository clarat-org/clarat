require_relative '../test_helper'

describe User do
  let(:user) { User.new }

  subject { user }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :email }
    it { subject.must_respond_to :encrypted_password }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :role }
  end

  describe 'validations' do
    describe 'always' do
      it { user.must validate_presence_of :email }
      it { user.must validate_uniqueness_of :email }
    end
  end

  describe 'methods' do
    describe '::system_user' do
      it 'should find an existing system user' do
        factory_user = FactoryGirl.create :user, name: 'System'
        assert_no_difference 'User.count' do
          user = User.system_user
          user.must_equal factory_user
        end
      end

      it 'should create a system user when none exists' do
        assert_difference 'User.count', 1 do
          User.system_user.name.must_equal 'System'
        end
      end
    end
  end
end
