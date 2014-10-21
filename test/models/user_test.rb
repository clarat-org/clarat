require 'test_helper'

describe User do

  let(:user) { User.new }

  subject { user }

  describe 'attributes' do
    it {subject.must_respond_to :id }
    it {subject.must_respond_to :email }
    it {subject.must_respond_to :encrypted_password }
    it {subject.must_respond_to :created_at }
    it {subject.must_respond_to :created_at }
    it {subject.must_respond_to :admin }
  end
end
